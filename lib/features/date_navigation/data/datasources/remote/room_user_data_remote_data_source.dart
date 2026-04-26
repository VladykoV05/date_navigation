import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';
import 'firestore_error_guard.dart';

class RoomUserDataRemoteDataSource {
  const RoomUserDataRemoteDataSource(
    this._firestore,
    this._mapFirestoreFailure, {
    required String Function({
      required String placeName,
      double? lat,
      double? lon,
    })
    favoriteDocId,
  }) : _favoriteDocId = favoriteDocId;

  final FirebaseFirestore _firestore;
  final Failure Function(FirebaseException e, {required String fallback})
  _mapFirestoreFailure;
  final String Function({required String placeName, double? lat, double? lon})
  _favoriteDocId;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRecentHistory({
    required String usersCollection,
    required String userId,
    int limit = 10,
  }) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection('meeting_history')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchFavorites({
    required String usersCollection,
    required String userId,
    int limit = 100,
  }) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection('favorites')
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchFrequentAddresses({
    required String usersCollection,
    required String userId,
    int limit = 20,
  }) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection('address_memory')
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<Result<void>> upsertFavorite({
    required String usersCollection,
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final userRef = _firestore.collection(usersCollection).doc(userId);
      final favoriteRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(_favoriteDocId(placeName: placeName, lat: lat, lon: lon));
      await userRef.set({
        'lastActivityAt': FieldValue.serverTimestamp(),
        'lastActivityType': 'favorite_upsert',
      }, SetOptions(merge: true));
      await favoriteRef.set({
        'placeName': placeName,
        'placeAddress': placeAddress,
        'placeType': placeType,
        'lat': lat,
        'lon': lon,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось сохранить в избранное',
    );
  }

  Future<Result<void>> removeFavorite({
    required String usersCollection,
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final favoriteRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(_favoriteDocId(placeName: placeName, lat: lat, lon: lon));
      await favoriteRef.delete();
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось удалить из избранного',
    );
  }

  Future<Result<void>> rememberAddress({
    required String usersCollection,
    required String userId,
    required String address,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final normalizedAddress = address.trim();
      if (normalizedAddress.isEmpty) return;
      final userRef = _firestore.collection(usersCollection).doc(userId);
      final addressRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('address_memory')
          .doc(_addressDocId(normalizedAddress));
      await userRef.set({
        'lastActivityAt': FieldValue.serverTimestamp(),
        'lastActivityType': 'address_remember',
      }, SetOptions(merge: true));
      await addressRef.set({
        'address': normalizedAddress,
        'usesCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось сохранить адрес',
    );
  }

  Future<Result<void>> removeRememberedAddress({
    required String usersCollection,
    required String userId,
    required String address,
  }) async {
    return FirestoreErrorGuard.runVoid(
      () async {
      final normalizedAddress = address.trim();
      if (normalizedAddress.isEmpty) return;
      final addressRef = _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('address_memory')
          .doc(_addressDocId(normalizedAddress));
      await addressRef.delete();
      },
      mapper: _mapFirestoreFailure,
      fallback: 'Не удалось удалить адрес',
    );
  }

  String _addressDocId(String address) {
    final normalized = address.toLowerCase();
    final sanitized = normalized.replaceAll(
      RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false),
      '_',
    );
    return sanitized.isEmpty ? 'address_entry' : sanitized;
  }
}
