import { test, before, after, beforeEach } from 'node:test';
import { readFileSync } from 'node:fs';
import { initializeTestEnvironment, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import { doc, setDoc, getDoc, updateDoc, serverTimestamp } from 'firebase/firestore';

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'date-navigation-test',
    firestore: { host: '127.0.0.1', port: 8080, rules: readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8') },
  });
});
after(async () => env.cleanup());
beforeEach(async () => env.clearFirestore());

const as = (uid) => env.authenticatedContext(uid).firestore();
const anon = () => env.unauthenticatedContext().firestore();

test('any signed-in user can read a public profile', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'publicProfiles/alice'), { googleName: 'Alice' });
  });
  await assertSucceeds(getDoc(doc(as('bob'), 'publicProfiles/alice')));
});

test('anonymous user cannot read public profiles', async () => {
  await assertFails(getDoc(doc(anon(), 'publicProfiles/alice')));
});

test('owner writes own profile with allowed fields', async () => {
  await assertSucceeds(setDoc(doc(as('alice'), 'publicProfiles/alice'), {
    displayName: 'Alice', googleName: 'Alice', photoUrl: 'https://x/y.jpg',
    avatarBase64: null, avatarPreset: 3, updatedAt: serverTimestamp(),
  }));
});

test('user cannot write someone else profile', async () => {
  await assertFails(setDoc(doc(as('bob'), 'publicProfiles/alice'), { displayName: 'Hacked' }));
});

test('unknown field is rejected', async () => {
  await assertFails(setDoc(doc(as('alice'), 'publicProfiles/alice'), { displayName: 'A', role: 'admin' }));
});

test('display name longer than 40 chars is rejected', async () => {
  await assertFails(setDoc(doc(as('alice'), 'publicProfiles/alice'), { displayName: 'a'.repeat(41) }));
});

test('avatar longer than 45000 chars is rejected', async () => {
  await assertFails(setDoc(doc(as('alice'), 'publicProfiles/alice'), { avatarBase64: 'a'.repeat(45001) }));
});

test('preset index outside 0..11 is rejected', async () => {
  await assertFails(setDoc(doc(as('alice'), 'publicProfiles/alice'), { avatarPreset: 12 }));
});

test('owner can reset avatar fields', async () => {
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'publicProfiles/alice'), { avatarPreset: 2, avatarBase64: null });
  });
  await assertSucceeds(updateDoc(doc(as('alice'), 'publicProfiles/alice'), { avatarPreset: null, avatarBase64: null }));
});
