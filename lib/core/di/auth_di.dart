import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_session.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authSessionProvider = Provider<AuthSession>(
  (ref) => FirebaseAuthSession(ref.watch(firebaseAuthProvider)),
);

final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).currentUser,
);
