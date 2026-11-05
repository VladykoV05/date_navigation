import { initializeApp, applicationDefault, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import process from 'node:process';

const projectId = process.env.FIREBASE_PROJECT_ID || 'date-navigation';
const apply = process.argv.includes('--apply');

function initFirebase() {
  const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (serviceAccountJson) {
    initializeApp({
      credential: cert(JSON.parse(serviceAccountJson)),
      projectId,
    });
    return;
  }
  initializeApp({ credential: applicationDefault(), projectId });
}

export function buildV2Room(id, data) {
  const creatorUid = String(data.creatorUid || data.createdBy || '').trim();
  if (!creatorUid) return null;
  const partnerUid = String(data.partnerUid || '').trim();
  const participants = Array.isArray(data.participants)
    ? data.participants.map((uid) => String(uid).trim()).filter(Boolean)
    : [creatorUid, partnerUid].filter(Boolean);

  const roomUpdate = {
    schemaVersion: 2,
    type: 'private',
    visibility: 'invite',
    capacity: 2,
    hostUid: creatorUid,
    participantCount: participants.length,
  };

  const participantDocs = {
    [creatorUid]: {
      role: 'host',
      point: data.point1 ?? null,
      searchRadius: data.creatorSearchRadius ?? null,
      meetingFormats: data.creatorMeetingFormats ?? [],
      selectedMeetingFormat:
        data.creatorSelectedMeetingFormat ?? data.selectedMeetingFormat ?? null,
    },
  };
  if (partnerUid) {
    participantDocs[partnerUid] = {
      role: 'member',
      point: data.point2 ?? null,
      searchRadius: data.partnerSearchRadius ?? null,
      meetingFormats: data.partnerMeetingFormats ?? [],
      selectedMeetingFormat:
        data.partnerSelectedMeetingFormat ?? data.selectedMeetingFormat ?? null,
    };
  }

  return { id, roomUpdate, participantDocs };
}

async function main() {
  initFirebase();
  const db = getFirestore();
  let scanned = 0;
  let migrated = 0;
  let skipped = 0;
  let lastDoc = null;

  while (true) {
    let query = db.collection('rooms').orderBy('__name__').limit(300);
    if (lastDoc) query = query.startAfter(lastDoc);
    const snapshot = await query.get();
    if (snapshot.empty) break;

    const batch = db.batch();
    for (const doc of snapshot.docs) {
      scanned += 1;
      const data = doc.data();
      if (Number(data.schemaVersion ?? 1) >= 2) {
        skipped += 1;
        continue;
      }
      const plan = buildV2Room(doc.id, data);
      if (!plan) {
        skipped += 1;
        continue;
      }
      migrated += 1;
      if (apply) {
        batch.set(doc.ref, plan.roomUpdate, { merge: true });
        for (const [uid, participant] of Object.entries(plan.participantDocs)) {
          batch.set(
            doc.ref.collection('participants').doc(uid),
            participant,
            { merge: true },
          );
        }
      }
    }
    if (apply) await batch.commit();
    lastDoc = snapshot.docs[snapshot.docs.length - 1];
    if (snapshot.size < 300) break;
  }

  console.log(
    `migrate_rooms_v2: scanned=${scanned}, migrated=${migrated}, skipped=${skipped}, apply=${apply}`,
  );
  if (!apply) {
    console.log('Dry run. Re-run with --apply to write changes.');
  }
}

if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch((error) => {
    console.error('migration failed:', error);
    process.exitCode = 1;
  });
}
