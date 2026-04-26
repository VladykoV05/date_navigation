import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/auth_di.dart';
import '../../../core/services/auth_session.dart';

final accountFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final accountCurrentUserProvider = Provider<User?>(
  (ref) => ref.watch(currentUserProvider),
);

final accountAuthSessionProvider = Provider<AuthSession>(
  (ref) => ref.watch(authSessionProvider),
);
