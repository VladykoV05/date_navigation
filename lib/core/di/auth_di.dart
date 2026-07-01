import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_session.dart';
import '../services/auth_sign_in_service.dart';
import '../services/auth_sign_out_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authSessionProvider = Provider<AuthSession>(
  (ref) => FirebaseAuthSession(ref.watch(firebaseAuthProvider)),
);

final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).currentUser,
);

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
