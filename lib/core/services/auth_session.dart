import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthSession {
  String? get currentUserId;
  Stream<User?> authStateChanges();
  Future<void> signOut();
}

class FirebaseAuthSession implements AuthSession {
  FirebaseAuthSession(this._auth);

  final FirebaseAuth _auth;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  Future<void> signOut() => _auth.signOut();
}
