import { test, before, after, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, updateDoc, getDoc, serverTimestamp, Timestamp, arrayUnion } from 'firebase/firestore';

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

async function seedOpenRoom(capacity, participants) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'rooms/open1'), {
      schemaVersion: 2, type: 'open', visibility: 'public', capacity,
      hostUid: 'host', creatorUid: 'host', participants, participantCount: participants.length,
      sessionStatus: 'active', updatedAt: Timestamp.now(), expiresAt: future(),
    });
  });
}

test('host can create an open room with host participant doc', async () => {
  const db = as('host');
  await assertSucceeds(setDoc(doc(db, 'rooms/r1'), {
    schemaVersion: 2, type: 'open', visibility: 'public', capacity: 4,
    hostUid: 'host', creatorUid: 'host', participants: ['host'], participantCount: 1,
    sessionStatus: 'active', updatedAt: serverTimestamp(), expiresAt: future(),
  }));
  await assertSucceeds(setDoc(doc(db, 'rooms/r1/participants/host'), { role: 'host' }));
});

test('create rejects capacity out of range', async () => {
  await assertFails(setDoc(doc(as('host'), 'rooms/r2'), {
    creatorUid: 'host', capacity: 99, type: 'open',
  }));
});

test('member joins open room with one uid appended', async () => {
  await seedOpenRoom(3, ['host']);
  const db = as('guest');
  await assertSucceeds(updateDoc(doc(db, 'rooms/open1'), {
    participants: ['host', 'guest'], participantCount: 2, updatedAt: serverTimestamp(),
  }));
  await assertSucceeds(setDoc(doc(db, 'rooms/open1/participants/guest'), { role: 'member' }));
});

test('join rejected when room is full', async () => {
  await seedOpenRoom(2, ['host', 'a']);
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    participants: ['host', 'a', 'guest'], participantCount: 3, updatedAt: serverTimestamp(),
  }));
});

test('member cannot change capacity or type of open room', async () => {
  await seedOpenRoom(3, ['host']);
  await assertFails(updateDoc(doc(as('host'), 'rooms/open1'), { capacity: 20 }));
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    participants: ['host', 'guest'], participantCount: 2, capacity: 20, updatedAt: serverTimestamp(),
  }));
});

test('user cannot add someone else to participants', async () => {
  await seedOpenRoom(3, ['host']);
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    participants: ['host', 'someoneElse'], participantCount: 2, updatedAt: serverTimestamp(),
  }));
});

test('participant doc cannot be created for another user', async () => {
  await seedOpenRoom(3, ['host']);
  await assertFails(setDoc(doc(as('guest'), 'rooms/open1/participants/victim'), { role: 'member' }));
});

test('participant docs cannot be updated or deleted', async () => {
  await seedOpenRoom(3, ['host']);
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/open1/participants/guest'), { role: 'member' });
  });
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1/participants/guest'), { role: 'host' }));
});

test('private room: partner join still works and sets partner fields', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/priv1'), {
      creatorUid: 'host', createdBy: 'host', partnerUid: null,
      participants: ['host'], sessionStatus: 'active', expiresAt: future(),
    });
  });
  await assertSucceeds(updateDoc(doc(as('partner'), 'rooms/priv1'), {
    partnerUid: 'partner', participants: ['host', 'partner'], partnerSearchRadius: 500,
    updatedAt: serverTimestamp(),
  }));
});

test('private room: creator cannot change partner-owned fields', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/priv2'), {
      creatorUid: 'host', createdBy: 'host', partnerUid: 'partner',
      participants: ['host', 'partner'], point2: { lat: 1, lng: 1 }, sessionStatus: 'active', expiresAt: future(),
    });
  });
  await assertFails(updateDoc(doc(as('host'), 'rooms/priv2'), { point2: { lat: 2, lng: 2 } }));
});
