import { test, before, after, beforeEach } from 'node:test';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, updateDoc, writeBatch, serverTimestamp, Timestamp, collection, addDoc } from 'firebase/firestore';

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

async function seed(participants, sessionStatus = 'active') {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'rooms/open1'), {
      schemaVersion: 2, type: 'open', visibility: 'public', capacity: 5,
      hostUid: 'host', creatorUid: 'host', createdBy: 'host', participants,
      participantCount: participants.length, sessionStatus, updatedAt: Timestamp.now(), expiresAt: future(),
    });
    for (const uid of participants) {
      await setDoc(doc(db, `rooms/open1/participants/${uid}`), { role: uid === 'host' ? 'host' : 'member' });
    }
  });
}

// Mirrors the client transaction: host leaves, ownership moves to newHost.
function transferBatch(db, remaining, newHost) {
  const batch = writeBatch(db);
  batch.update(doc(db, 'rooms/open1'), {
    participants: remaining, participantCount: remaining.length,
    creatorUid: newHost, createdBy: newHost, hostUid: newHost, updatedAt: serverTimestamp(),
  });
  batch.delete(doc(db, 'rooms/open1/participants/host'));
  return batch;
}

test('host leaves: ownership moves to participants[1] in one commit', async () => {
  await seed(['host', 'a', 'guest']);
  await assertSucceeds(transferBatch(as('host'), ['a', 'guest'], 'a').commit());
});

test('transfer must go to the earliest member (participants[1])', async () => {
  await seed(['host', 'a', 'guest']);
  await assertFails(transferBatch(as('host'), ['a', 'guest'], 'guest').commit());
});

test('host alone cannot leave by transfer', async () => {
  await seed(['host']);
  await assertFails(transferBatch(as('host'), [], 'host').commit());
});

test('member cannot take over the host role', async () => {
  await seed(['host', 'a', 'guest']);
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    participants: ['host', 'a'], participantCount: 2, creatorUid: 'guest', createdBy: 'guest', hostUid: 'guest',
    updatedAt: serverTimestamp(),
  }));
});

test('transfer is not allowed after the session ended', async () => {
  await seed(['host', 'a', 'guest'], 'completed');
  await assertFails(transferBatch(as('host'), ['a', 'guest'], 'a').commit());
});

test('new host can end the session after the transfer', async () => {
  await seed(['host', 'a', 'guest']);
  await assertSucceeds(transferBatch(as('host'), ['a', 'guest'], 'a').commit());
  await assertSucceeds(updateDoc(doc(as('a'), 'rooms/open1'), {
    sessionStatus: 'completed', completedAt: serverTimestamp(), completedBy: 'a', updatedAt: serverTimestamp(),
  }));
});

test('old host loses control after the transfer', async () => {
  await seed(['host', 'a', 'guest']);
  await assertSucceeds(transferBatch(as('host'), ['a', 'guest'], 'a').commit());
  await assertFails(updateDoc(doc(as('host'), 'rooms/open1'), {
    sessionStatus: 'completed', completedAt: serverTimestamp(), completedBy: 'host', updatedAt: serverTimestamp(),
  }));
});

test('new host can still post chat messages', async () => {
  await seed(['host', 'a', 'guest']);
  await assertSucceeds(transferBatch(as('host'), ['a', 'guest'], 'a').commit());
  await assertSucceeds(addDoc(collection(as('a'), 'rooms/open1/messages'), {
    senderUid: 'a', text: 'hi', kind: 'text', clientId: 'h1', createdAt: serverTimestamp(),
  }));
});
