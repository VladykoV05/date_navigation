import { cert, getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";

import { config } from "./config";

function ensureApp(): void {
  if (getApps().length > 0) return;

  const raw = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (raw) {
    initializeApp({
      credential: cert(JSON.parse(raw)),
      projectId: config.projectId,
    });
    return;
  }

  initializeApp({ projectId: config.projectId });
}

export function auth() {
  ensureApp();
  return getAuth();
}

export function db() {
  ensureApp();
  return getFirestore();
}
