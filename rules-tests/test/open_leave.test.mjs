import { test, before, after, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, updateDoc, deleteDoc, writeBatch, getDoc, serverTimestamp, Timestamp, collection, addDoc } from 'firebase/firestore';

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

// Room with host + two members, each with a participant doc.
async function seed() {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'rooms/open1'), {
      schemaVersion: 2, type: 'open', visibility: 'public', capacity: 4,
      hostUid: 'host', creatorUid: 'host', participants: ['host', 'a', 'guest'],
      participantCount: 3, sessionStatus: 'active', updatedAt: Timestamp.now(), expiresAt: future(),
    });
    await setDoc(doc(db, 'rooms/open1/participants/host'), { role: 'host' });
    await setDoc(doc(db, 'rooms/open1/participants/a'), { role: 'member' });
    await setDoc(doc(db, 'rooms/open1/participants/guest'), { role: 'member' });
  });
}

// Mirrors the client transaction: room update + own participant delete in one commit.
function leaveBatch(db, uid, remaining, count) {
  const batch = writeBatch(db);
  batch.update(doc(db, 'rooms/open1'), {
    participants: remaining, participantCount: count, updatedAt: serverTimestamp(),
  });
  batch.delete(doc(db, `rooms/open1/participants/${uid}`));
  return batch.commit();
}

test('member leaves: room update and own participant delete succeed together', async () => {
  await seed();
  await assertSucceeds(leaveBatch(as('guest'), 'guest', ['host', 'a'], 2));
  let exists = true;
  await env.withSecurityRulesDisabled(async (ctx) => {
    exists = (await getDoc(doc(ctx.firestore(), 'rooms/open1/participants/guest'))).exists();
  });
  assert.equal(exists, false);
});

test('member cannot delete another participant document', async () => {
  await seed();
  await assertFails(deleteDoc(doc(as('guest'), 'rooms/open1/participants/a')));
});

test('member cannot leave while leaving someone else in the room', async () => {
  await seed();
  await assertFails(leaveBatch(as('guest'), 'guest', ['host'], 1));
});

test('leave must decrement participantCount by exactly one', async () => {
  await seed();
  await assertFails(leaveBatch(as('guest'), 'guest', ['host', 'a'], 3));
});

test('leave must not change other room fields', async () => {
  await seed();
  const db = as('guest');
  const batch = writeBatch(db);
  batch.update(doc(db, 'rooms/open1'), {
    participants: ['host', 'a'], participantCount: 2, capacity: 20, updatedAt: serverTimestamp(),
  });
  batch.delete(doc(db, 'rooms/open1/participants/guest'));
  await assertFails(batch.commit());
});

test('host cannot leave through the room update', async () => {
  await seed();
  await assertFails(updateDoc(doc(as('host'), 'rooms/open1'), {
    participants: ['a', 'guest'], participantCount: 2, updatedAt: serverTimestamp(),
  }));
});

test('host cannot delete own participant document', async () => {
  await seed();
  await assertFails(deleteDoc(doc(as('host'), 'rooms/open1/participants/host')));
});

test('non-participant cannot remove a member from the room', async () => {
  await seed();
  await assertFails(updateDoc(doc(as('stranger'), 'rooms/open1'), {
    participants: ['host', 'a'], participantCount: 2, updatedAt: serverTimestamp(),
  }));
});

test('leaver can post system message before leaving', async () => {
  await seed();
  await assertSucceeds(addDoc(collection(as('guest'), 'rooms/open1/messages'), {
    senderUid: 'guest', text: 'participant_left', kind: 'system',
    clientId: 'c1', createdAt: serverTimestamp(),
  }));
  await assertSucceeds(leaveBatch(as('guest'), 'guest', ['host', 'a'], 2));
});
