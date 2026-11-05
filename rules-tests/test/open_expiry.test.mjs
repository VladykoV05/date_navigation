import { test, before, after, beforeEach } from 'node:test';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, updateDoc, serverTimestamp, Timestamp, collection, addDoc } from 'firebase/firestore';

let env;
const inHours = (h) => Timestamp.fromDate(new Date(Date.now() + h * 3600_000));

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'date-navigation-test',
    firestore: { host: '127.0.0.1', port: 8080, rules: readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8') },
  });
});
after(async () => env.cleanup());
beforeEach(async () => env.clearFirestore());

const as = (uid) => env.authenticatedContext(uid).firestore();

async function seed(expiresAt, participants = ['host', 'guest']) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'rooms/open1'), {
      schemaVersion: 2, type: 'open', visibility: 'public', capacity: 4,
      hostUid: 'host', creatorUid: 'host', participants, participantCount: participants.length,
      sessionStatus: 'active', updatedAt: Timestamp.now(), expiresAt,
    });
    for (const uid of participants) {
      await setDoc(doc(db, `rooms/open1/participants/${uid}`), { role: uid === 'host' ? 'host' : 'member' });
    }
  });
}

const expire = (db) => updateDoc(doc(db, 'rooms/open1'), { sessionStatus: 'expired', updatedAt: serverTimestamp() });

test('participant persists expiry after the time is up', async () => {
  await seed(inHours(-1));
  await assertSucceeds(expire(as('guest')));
});

test('expiry is rejected while the session time is still running', async () => {
  await seed(inHours(5));
  await assertFails(expire(as('guest')));
});

test('non-participant cannot expire the room', async () => {
  await seed(inHours(-1));
  await assertFails(expire(as('stranger')));
});

test('expiry cannot change other fields', async () => {
  await seed(inHours(-1));
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    sessionStatus: 'expired', capacity: 20, updatedAt: serverTimestamp(),
  }));
});

test('nobody can join after expiresAt', async () => {
  await seed(inHours(-1), ['host']);
  await assertFails(updateDoc(doc(as('newcomer'), 'rooms/open1'), {
    participants: ['host', 'newcomer'], participantCount: 2, updatedAt: serverTimestamp(),
  }));
});

test('text messages are rejected after expiresAt', async () => {
  await seed(inHours(-1));
  await assertFails(addDoc(collection(as('guest'), 'rooms/open1/messages'), {
    senderUid: 'guest', text: 'late', kind: 'text', clientId: 'x1', createdAt: serverTimestamp(),
  }));
});

test('text messages are allowed before expiresAt', async () => {
  await seed(inHours(5));
  await assertSucceeds(addDoc(collection(as('guest'), 'rooms/open1/messages'), {
    senderUid: 'guest', text: 'ok', kind: 'text', clientId: 'x2', createdAt: serverTimestamp(),
  }));
});
