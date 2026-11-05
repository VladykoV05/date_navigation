import { test, before, after, beforeEach } from 'node:test';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, updateDoc, deleteDoc, writeBatch, serverTimestamp, Timestamp, collection, addDoc } from 'firebase/firestore';

let env;
const future = () => Timestamp.fromDate(new Date(Date.now() + 3600_000));

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'date-navigation-test',
    firestore: { host: '127.0.0.1', port: 8080, rules: readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8') },
  });
});
after(async () => env.cleanup());
beforeEach(async () => env.clearFirestore());

const as = (uid) => env.authenticatedContext(uid).firestore();

async function seed(sessionStatus = 'active') {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'rooms/open1'), {
      schemaVersion: 2, type: 'open', visibility: 'public', capacity: 4,
      hostUid: 'host', creatorUid: 'host', participants: ['host', 'guest'],
      participantCount: 2, sessionStatus, updatedAt: Timestamp.now(), expiresAt: future(),
    });
    await setDoc(doc(db, 'rooms/open1/participants/host'), { role: 'host' });
    await setDoc(doc(db, 'rooms/open1/participants/guest'), { role: 'member' });
  });
}

const completeUpdate = (db, extra = {}) => updateDoc(doc(db, 'rooms/open1'), {
  sessionStatus: 'completed', completedAt: serverTimestamp(), completedBy: 'host',
  updatedAt: serverTimestamp(), ...extra,
});

test('host completes an open room', async () => {
  await seed();
  await assertSucceeds(completeUpdate(as('host')));
});

test('member cannot complete the room', async () => {
  await seed();
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    sessionStatus: 'completed', completedAt: serverTimestamp(), completedBy: 'guest',
    updatedAt: serverTimestamp(),
  }));
});

test('completion cannot change participants at the same time', async () => {
  await seed();
  await assertFails(completeUpdate(as('host'), { participants: ['host'], participantCount: 1 }));
});

test('completed room rejects new joins', async () => {
  await seed();
  await assertSucceeds(completeUpdate(as('host')));
  await assertFails(updateDoc(doc(as('newcomer'), 'rooms/open1'), {
    participants: ['host', 'guest', 'newcomer'], participantCount: 3, updatedAt: serverTimestamp(),
  }));
});

test('completed room rejects chat messages from members', async () => {
  await seed();
  await assertSucceeds(completeUpdate(as('host')));
  await assertFails(addDoc(collection(as('guest'), 'rooms/open1/messages'), {
    senderUid: 'guest', text: 'hello', kind: 'text', clientId: 'c2', createdAt: serverTimestamp(),
  }));
});

test('chat messages are allowed while the room is active', async () => {
  await seed();
  await assertSucceeds(addDoc(collection(as('guest'), 'rooms/open1/messages'), {
    senderUid: 'guest', text: 'hello', kind: 'text', clientId: 'c3', createdAt: serverTimestamp(),
  }));
});

test('member can still leave a completed room', async () => {
  await seed();
  await assertSucceeds(completeUpdate(as('host')));
  const db = as('guest');
  const batch = writeBatch(db);
  batch.update(doc(db, 'rooms/open1'), {
    participants: ['host'], participantCount: 1, updatedAt: serverTimestamp(),
  });
  batch.delete(doc(db, 'rooms/open1/participants/guest'));
  await assertSucceeds(batch.commit());
});
