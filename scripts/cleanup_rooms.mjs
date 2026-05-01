import { initializeApp, applicationDefault, cert } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import process from 'node:process';

const projectId = process.env.FIREBASE_PROJECT_ID || 'date-navigation';
const completedTtlHours = Number(process.env.ROOM_COMPLETED_TTL_HOURS || 24);

function initFirebase() {
  const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (serviceAccountJson) {
    const serviceAccount = JSON.parse(serviceAccountJson);
    initializeApp({
      credential: cert(serviceAccount),
      projectId,
    });
    return;
  }

  initializeApp({
    credential: applicationDefault(),
    projectId,
  });
}

async function deleteByQuery(db, query, label) {
  let totalDeleted = 0;
  while (true) {
    const snapshot = await query.limit(300).get();
    if (snapshot.empty) break;

    const batch = db.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
    totalDeleted += snapshot.size;
  }
  console.log(`${label}: deleted ${totalDeleted}`);
  return totalDeleted;
}

async function main() {
  initFirebase();
  const db = getFirestore();
  const now = Timestamp.now();
  const completedBefore = Timestamp.fromDate(
    new Date(Date.now() - completedTtlHours * 60 * 60 * 1000),
  );

  const expiredInvites = db
    .collection('roomInvites')
    .where('expiresAt', '<=', now);

  const expiredRooms = db.collection('rooms').where('expiresAt', '<=', now);

  const staleCompletedRooms = db
    .collection('rooms')
    .where('sessionStatus', '==', 'completed')
    .where('completedAt', '<=', completedBefore);

  const deletedInvites = await deleteByQuery(
    db,
    expiredInvites,
    'expired roomInvites',
  );
  const deletedExpiredRooms = await deleteByQuery(db, expiredRooms, 'expired rooms');
  const deletedCompletedRooms = await deleteByQuery(
    db,
    staleCompletedRooms,
    'stale completed rooms',
  );

  console.log(
    `Done. invites=${deletedInvites}, expiredRooms=${deletedExpiredRooms}, staleCompletedRooms=${deletedCompletedRooms}`,
  );
}

main().catch((error) => {
  console.error('cleanup failed:', error);
  process.exitCode = 1;
});
