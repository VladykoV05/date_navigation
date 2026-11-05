import 'package:cloud_firestore/cloud_firestore.dart';

import '../error/failure.dart';
import '../error/failure_codes.dart';
import '../error/result.dart';
import 'public_profile.dart';

class PublicProfileRemoteDataSource {
  PublicProfileRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String collection = 'publicProfiles';

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection(collection).doc(uid);

  Stream<PublicProfile?> watch(String uid) {
    return _doc(uid).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return null;
      return fromMap(uid, data);
    });
  }

  static PublicProfile fromMap(String uid, Map<String, dynamic> data) {
    String? text(Object? value) {
      if (value is! String) return null;
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final preset = data['avatarPreset'];
    return PublicProfile(
      uid: uid,
      displayName: text(data['displayName']),
      googleName: text(data['googleName']),
      photoUrl: text(data['photoUrl']),
      avatarBase64: text(data['avatarBase64']),
      avatarPreset: preset is int ? preset : null,
    );
  }

  Future<Result<void>> syncFromAuth({
    required String uid,
    String? googleName,
    String? photoUrl,
  }) async {
    try {
      await _firestore.runTransaction((tx) async {
        final ref = _doc(uid);
        final snap = await tx.get(ref);
        final data = snap.data() ?? <String, dynamic>{};
        final hasName =
            (data['displayName'] as String?)?.trim().isNotEmpty == true;
        tx.set(ref, {
          'googleName': ?googleName,
          'photoUrl': ?photoUrl,
          if (!hasName && googleName != null) 'displayName': googleName,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
      return const Ok(null);
    } on FirebaseException {
      return const Err(UnknownFailure(FailureCodes.profileSaveFailed));
    }
  }

  Future<Result<void>> _update(String uid, Map<String, dynamic> fields) async {
    try {
      await _doc(uid).set({
        ...fields,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return const Ok(null);
    } on FirebaseException {
      return const Err(UnknownFailure(FailureCodes.profileSaveFailed));
    }
  }

  Future<Result<void>> rename(String uid, String name) =>
      _update(uid, {'displayName': name});

  Future<Result<void>> setAvatarBase64(String uid, String base64) =>
      _update(uid, {'avatarBase64': base64, 'avatarPreset': null});

  Future<Result<void>> setPreset(String uid, int preset) =>
      _update(uid, {'avatarPreset': preset, 'avatarBase64': null});

  Future<Result<void>> resetAvatar(String uid) =>
      _update(uid, {'avatarBase64': null, 'avatarPreset': null});
}
