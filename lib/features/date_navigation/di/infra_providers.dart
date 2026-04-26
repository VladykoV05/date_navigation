import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../../core/di/auth_di.dart';
import '../../../core/services/auth_sign_out_service.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final authSignOutServiceProvider = Provider<AuthSignOutService>(
  (ref) => AuthSignOutService(
    authSession: ref.watch(authSessionProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);
