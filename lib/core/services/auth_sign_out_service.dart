import 'package:google_sign_in/google_sign_in.dart';

import 'auth_session.dart';

class AuthSignOutService {
  const AuthSignOutService({
    required AuthSession authSession,
    required GoogleSignIn googleSignIn,
  }) : _authSession = authSession,
       _googleSignIn = googleSignIn;

  final AuthSession _authSession;
  final GoogleSignIn _googleSignIn;

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore Google SDK signOut errors and continue Firebase signOut.
    }
    await _authSession.signOut();
  }
}
