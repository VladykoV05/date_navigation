import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../error/failure.dart';
import '../error/failure_codes.dart';
import '../error/result.dart';
import '../utils/observability.dart';

/// Deletes the signed-in Firebase user and personal Firestore subcollections.
class AccountDeletionService {
  AccountDeletionService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _auth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Future<Result<void>> deleteCurrentAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      return const Err(UnknownFailure(FailureCodes.userNotAuthenticated));
    }

    final uid = user.uid;
    Observability.breadcrumb('account_delete_start', data: {'uid': uid});

    try {
      await _deleteUserSubcollection(uid, 'favorites');
      await _deleteUserSubcollection(uid, 'meeting_history');
      await _deleteUserSubcollection(uid, 'address_memory');
      await _firestore.collection('users').doc(uid).delete();

      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      await user.delete();
      Observability.breadcrumb('account_delete_ok');
      return const Ok(null);
    } on FirebaseAuthException catch (e, stack) {
      await Observability.recordNonFatal(e, stack, reason: 'account_delete');
      return Err(
        UnknownFailure(
          e.code == 'requires-recent-login'
              ? FailureCodes.userNotAuthenticated
              : FailureCodes.deleteAccountFailed,
        ),
      );
    } catch (e, stack) {
      await Observability.recordNonFatal(e, stack, reason: 'account_delete');
      return const Err(UnknownFailure(FailureCodes.deleteAccountFailed));
    }
  }

  Future<void> _deleteUserSubcollection(String uid, String name) async {
    final collection = _firestore.collection('users').doc(uid).collection(name);
    final snap = await collection.limit(200).get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
