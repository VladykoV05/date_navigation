import { test, before, after, beforeEach } from 'node:test';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, updateDoc, writeBatch, serverTimestamp, Timestamp, collection } from 'firebase/firestore';

let env;
const future = () => Timestamp.fromDate(new Date(Date.now() + 3600_000));
const hoursAgo = (h) => Timestamp.fromDate(new Date(Date.now() - h * 3600_000));

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'date-navigation-test',
    firestore: { host: '127.0.0.1', port: 8080, rules: readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8') },
  });
});
after(async () => env.cleanup());
beforeEach(async () => env.clearFirestore());

const as = (uid) => env.authenticatedContext(uid).firestore();

async function seed({ sessionStatus = 'active', counter = null, expiresAt = future() } = {}) {
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'rooms/open1'), {
      schemaVersion: 2, type: 'open', visibility: 'public', capacity: 6,
      hostUid: 'host', creatorUid: 'host', createdBy: 'host', participants: ['host', 'guest'],
      participantCount: 2, sessionStatus, updatedAt: Timestamp.now(), expiresAt,
    });
    await setDoc(doc(db, 'rooms/open1/participants/host'), { role: 'host' });
    await setDoc(doc(db, 'rooms/open1/participants/guest'), counter
      ? { role: 'member', suggestionWindowStart: counter.start, suggestionCount: counter.count }
      : { role: 'member' });
  });
}

const suggestion = () => ({
  placeName: 'Бар', placeAddress: 'ул. Тест, 1', placeType: 'bar', lat: 53.9, lon: 27.5,
  status: 'suggested', createdAt: serverTimestamp(),
});

// Mirrors the client transaction: suggestion + participant counter in one commit.
function suggestBatch(db, uid, counterPatch, extra = {}) {
  const batch = writeBatch(db);
  const id = `s${Math.random().toString(36).slice(2, 8)}`;
  batch.set(doc(db, `rooms/open1/suggestions/${id}`), { ...suggestion(), proposedBy: uid, ...extra });
  batch.update(doc(db, `rooms/open1/participants/${uid}`), { ...counterPatch, updatedAt: serverTimestamp() });
  return batch.commit();
}

test('participant proposes a place with a fresh counter', async () => {
  await seed();
  await assertSucceeds(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: serverTimestamp(), suggestionCount: 1 }));
});

test('suggestion must be proposed by the caller', async () => {
  await seed();
  await assertFails(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: serverTimestamp(), suggestionCount: 1 }, { proposedBy: 'host' }));
});

test('non-participant cannot propose', async () => {
  await seed();
  const db = as('stranger');
  await assertFails(setDoc(doc(db, 'rooms/open1/suggestions/x1'), { ...suggestion(), proposedBy: 'stranger' }));
});

test('sixth suggestion within the hour is rejected', async () => {
  await seed({ counter: { start: hoursAgo(0.5), count: 5 } });
  await assertFails(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: hoursAgo(0.5), suggestionCount: 6 }));
});

test('counter after the window expired restarts at 1', async () => {
  await seed({ counter: { start: hoursAgo(2), count: 5 } });
  await assertSucceeds(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: serverTimestamp(), suggestionCount: 1 }));
});

test('counter cannot skip ahead (count + 2)', async () => {
  await seed({ counter: { start: hoursAgo(0.5), count: 1 } });
  await assertFails(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: hoursAgo(0.5), suggestionCount: 3 }));
});

test('window start cannot be moved while the window is running', async () => {
  await seed({ counter: { start: hoursAgo(0.5), count: 1 } });
  await assertFails(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: serverTimestamp(), suggestionCount: 2 }));
});

test('suggestions are closed after the session ended', async () => {
  await seed({ sessionStatus: 'completed' });
  await assertFails(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: serverTimestamp(), suggestionCount: 1 }));
});

test('suggestions are closed after expiresAt', async () => {
  await seed({ expiresAt: hoursAgo(1) });
  await assertFails(suggestBatch(as('guest'), 'guest', { suggestionWindowStart: serverTimestamp(), suggestionCount: 1 }));
});

test('host marks a suggestion as chosen', async () => {
  await seed();
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/open1/suggestions/s1'), { ...suggestion(), proposedBy: 'guest' });
  });
  await assertSucceeds(updateDoc(doc(as('host'), 'rooms/open1/suggestions/s1'), { status: 'chosen', chosenAt: serverTimestamp() }));
});

test('participant cannot change suggestion status', async () => {
  await seed();
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/open1/suggestions/s1'), { ...suggestion(), proposedBy: 'guest' });
  });
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1/suggestions/s1'), { status: 'chosen' }));
});

test('suggestions cannot be deleted', async () => {
  await seed();
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'rooms/open1/suggestions/s1'), { ...suggestion(), proposedBy: 'guest' });
  });
  const { deleteDoc } = await import('firebase/firestore');
  await assertFails(deleteDoc(doc(as('host'), 'rooms/open1/suggestions/s1')));
});

test('host sets the next step and radius', async () => {
  await seed();
  await assertSucceeds(updateDoc(doc(as('host'), 'rooms/open1'), {
    nextStep: { name: 'Бар', lat: 53.9, lon: 27.5, chosenBy: 'host' }, planRadiusMeters: 1000, updatedAt: serverTimestamp(),
  }));
});

test('participant cannot set the next step', async () => {
  await seed();
  await assertFails(updateDoc(doc(as('guest'), 'rooms/open1'), {
    nextStep: { name: 'Бар', lat: 53.9, lon: 27.5 }, updatedAt: serverTimestamp(),
  }));
});

test('radius outside 300..3000 is rejected', async () => {
  await seed();
  await assertFails(updateDoc(doc(as('host'), 'rooms/open1'), { planRadiusMeters: 5000, updatedAt: serverTimestamp() }));
});
