import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/account_deletion_service.dart';
import '../services/auth_session.dart';
import '../services/auth_sign_in_service.dart';
import '../services/auth_sign_out_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authSessionProvider = Provider<AuthSession>(
  (ref) => FirebaseAuthSession(ref.watch(firebaseAuthProvider)),
);

/// Stable auth stream instance — do not call [AuthSession.authStateChanges]
/// directly in widgets (each call returns a new stream and remounts AuthGate).
final authStateChangesProvider = Provider<Stream<User?>>(
  (ref) => ref.watch(authSessionProvider).authStateChanges(),
);

final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authStateChangesProvider);
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final authSignInServiceProvider = Provider<AuthSignInService>(
  (ref) => AuthSignInService(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

final authSignOutServiceProvider = Provider<AuthSignOutService>(
  (ref) => AuthSignOutService(
    authSession: ref.watch(authSessionProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

final accountDeletionServiceProvider = Provider<AccountDeletionService>(
  (ref) => AccountDeletionService(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: FirebaseFirestore.instance,
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);
