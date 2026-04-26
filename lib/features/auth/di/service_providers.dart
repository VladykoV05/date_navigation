import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_sign_in_service.dart';
import 'infra_providers.dart';

final authSignInServiceProvider = Provider<AuthSignInService>(
  (ref) => AuthSignInService(
    firebaseAuth: ref.watch(authFirebaseAuthProvider),
    googleSignIn: ref.watch(authGoogleSignInProvider),
  ),
);
