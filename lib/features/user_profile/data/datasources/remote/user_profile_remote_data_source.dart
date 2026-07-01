import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/meeting_history_item.dart';
import '../../../domain/entities/remembered_address.dart';
import '../../../domain/entities/user_favorite.dart';

class UserProfileRemoteDataSource {
  UserProfileRemoteDataSource(this._firestore);

  static const _usersCollection = 'users';

  final FirebaseFirestore _firestore;

  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  }) {
    return _userCollection(userId, 'favorites')
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(_favoriteFromDoc)
              .where((favorite) => favorite.name.isNotEmpty)
              .toList(growable: false),
        );
  }

  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _userCollection(userId, 'meeting_history')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(_historyFromDoc)
              .where((item) => item.placeName.isNotEmpty)
              .toList(growable: false),
        );
  }

  Stream<List<RememberedAddress>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  }) {
    return _userCollection(userId, 'address_memory')
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(_rememberedAddressFromDoc)
              .where((item) => item.address.isNotEmpty)
              .toList(growable: false),
        );
  }

  Future<void> upsertFavorite({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    final normalizedName = placeName.trim();
    if (normalizedName.isEmpty) return;

    final userRef = _firestore.collection(_usersCollection).doc(userId);
    final favoriteRef = _userCollection(
      userId,
      'favorites',
    ).doc(favoriteDocId(placeName: normalizedName, lat: lat, lon: lon));
    await userRef.set({
      'lastActivityAt': FieldValue.serverTimestamp(),
      'lastActivityType': 'favorite_upsert',
    }, SetOptions(merge: true));
    await favoriteRef.set({
      'placeName': normalizedName,
      if (placeAddress != null && placeAddress.trim().isNotEmpty)
        'placeAddress': placeAddress.trim(),
      if (placeType != null && placeType.trim().isNotEmpty)
        'placeType': placeType.trim(),
      'lat': ?lat,
      'lon': ?lon,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeFavorite({
    required String userId,
    required String favoriteId,
  }) {
    return _userCollection(userId, 'favorites').doc(favoriteId).delete();
  }

  Future<void> removeFavoriteByPlace({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return removeFavorite(
      userId: userId,
      favoriteId: favoriteDocId(placeName: placeName, lat: lat, lon: lon),
    );
  }

  Future<void> rememberAddress({
    required String userId,
    required String address,
  }) async {
    final normalizedAddress = address.trim();
    if (normalizedAddress.isEmpty) return;

    final userRef = _firestore.collection(_usersCollection).doc(userId);
    final addressRef = _userCollection(
      userId,
      'address_memory',
    ).doc(addressDocId(normalizedAddress));
    await userRef.set({
      'lastActivityAt': FieldValue.serverTimestamp(),
      'lastActivityType': 'address_remember',
    }, SetOptions(merge: true));
    await addressRef.set({
      'address': normalizedAddress,
      'usesCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    final normalizedAddress = address.trim();
    if (normalizedAddress.isEmpty) return Future<void>.value();
    return _userCollection(
      userId,
      'address_memory',
    ).doc(addressDocId(normalizedAddress)).delete();
  }

  Future<void> recordMeetingHistory({
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) async {
    final normalizedPlaceName = placeName.trim();
    if (normalizedPlaceName.isEmpty || participantIds.isEmpty) return;

    final normalizedParticipantIds = participantIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (normalizedParticipantIds.isEmpty) return;

    final batch = _firestore.batch();
    for (final userId in normalizedParticipantIds) {
      final counterpartyUid = normalizedParticipantIds.firstWhere(
        (id) => id != userId,
        orElse: () => '',
      );
      final historyRef = _userCollection(userId, 'meeting_history').doc(roomId);
      batch.set(historyRef, {
        'roomId': roomId,
        'placeName': normalizedPlaceName,
        if (placeAddress != null && placeAddress.trim().isNotEmpty)
          'placeAddress': placeAddress.trim(),
        if (placeType != null && placeType.trim().isNotEmpty)
          'placeType': placeType.trim(),
        'lat': ?lat,
        'lon': ?lon,
        'createdAt': FieldValue.serverTimestamp(),
        'counterpartyUid': counterpartyUid,
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  CollectionReference<Map<String, dynamic>> _userCollection(
    String userId,
    String collection,
  ) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(collection);
  }

  static UserFavorite _favoriteFromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return UserFavorite(
      id: doc.id,
      name: (data['placeName'] ?? '').toString(),
      address: data['placeAddress']?.toString(),
      type: data['placeType']?.toString(),
      lat: (data['lat'] as num?)?.toDouble(),
      lon: (data['lon'] as num?)?.toDouble(),
    );
  }

  static MeetingHistoryItem _historyFromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return MeetingHistoryItem(
      id: doc.id,
      placeName: (data['placeName'] ?? '').toString(),
      placeAddress: data['placeAddress']?.toString(),
      placeType: data['placeType']?.toString(),
      lat: (data['lat'] as num?)?.toDouble(),
      lon: (data['lon'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      roomId: data['roomId']?.toString(),
      counterpartyUid: data['counterpartyUid']?.toString(),
    );
  }

  static RememberedAddress _rememberedAddressFromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return RememberedAddress(
      id: doc.id,
      address: (data['address'] ?? '').toString().trim(),
      usesCount: (data['usesCount'] as num?)?.toInt() ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static String favoriteDocId({
    required String placeName,
    double? lat,
    double? lon,
  }) {
    final normalized = placeName.trim().toLowerCase();
    final sanitized = normalized.replaceAll(
      RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false),
      '_',
    );
    final latPart = lat?.toStringAsFixed(5) ?? 'na';
    final lonPart = lon?.toStringAsFixed(5) ?? 'na';
    final base = sanitized.isEmpty ? 'favorite_place' : sanitized;
    return '${base}_${latPart}_$lonPart';
  }

  static String addressDocId(String address) {
    final normalized = address.toLowerCase();
    final sanitized = normalized.replaceAll(
      RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false),
      '_',
    );
    return sanitized.isEmpty ? 'address_entry' : sanitized;
  }
}
