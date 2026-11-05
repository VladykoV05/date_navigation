import { test, before, after, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, addDoc, collection, updateDoc, deleteDoc, serverTimestamp, Timestamp } from 'firebase/firestore';

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

async function seedRoom(participants = ['host', 'guest']) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/chat1'), {
      creatorUid: 'host', hostUid: 'host', participants,
      type: 'open', visibility: 'public', capacity: 4, participantCount: participants.length,
      sessionStatus: 'active', updatedAt: Timestamp.now(), expiresAt: future(),
    });
  });
}

const message = (senderUid, text = 'hello') => ({
  senderUid, kind: 'text', text, clientId: `c-${Math.random()}`,
  createdAt: serverTimestamp(),
});

test('participant can send a message', async () => {
  await seedRoom();
  await assertSucceeds(addDoc(collection(as('host'), 'rooms/chat1/messages'), message('host')));
});

test('outsider cannot read or send messages', async () => {
  await seedRoom();
  await assertFails(addDoc(collection(as('outsider'), 'rooms/chat1/messages'), message('outsider')));
});

test('senderUid must match auth uid', async () => {
  await seedRoom();
  await assertFails(addDoc(collection(as('host'), 'rooms/chat1/messages'), message('guest')));
});

test('message text is limited to 2000 chars', async () => {
  await seedRoom();
  await assertFails(addDoc(collection(as('host'), 'rooms/chat1/messages'), message('host', 'x'.repeat(2001))));
});

test('messages are immutable', async () => {
  await seedRoom();
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/chat1/messages/m1'), {
      senderUid: 'host', kind: 'text', text: 'hello', clientId: 'c1', createdAt: Timestamp.now(),
    });
  });
  await assertFails(updateDoc(doc(as('host'), 'rooms/chat1/messages/m1'), { text: 'edited' }));
  await assertFails(deleteDoc(doc(as('host'), 'rooms/chat1/messages/m1')));
});

test('participant can mark own read state only', async () => {
  await seedRoom();
  await assertSucceeds(setDoc(doc(as('host'), 'rooms/chat1/reads/host'), { lastReadAt: serverTimestamp() }));
  await assertFails(setDoc(doc(as('host'), 'rooms/chat1/reads/guest'), { lastReadAt: serverTimestamp() }));
});
