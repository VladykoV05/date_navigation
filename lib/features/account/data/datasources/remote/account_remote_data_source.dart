import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/account_favorite.dart';
import '../../../domain/entities/account_history_item.dart';

class AccountRemoteDataSource {
  static const _usersCollection = 'users';

  final FirebaseFirestore _firestore;
  AccountRemoteDataSource(this._firestore);

  Stream<List<AccountFavorite>> watchFavorites(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection('favorites')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) {
                final data = doc.data();
                return AccountFavorite(
                  id: doc.id,
                  name: (data['placeName'] ?? '').toString(),
                  address: data['placeAddress']?.toString(),
                  type: data['placeType']?.toString(),
                  lat: (data['lat'] as num?)?.toDouble(),
                  lon: (data['lon'] as num?)?.toDouble(),
                );
              })
              .where((f) => f.name.isNotEmpty)
              .toList(),
        );
  }

  Stream<List<AccountHistoryItem>> watchHistory(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection('meeting_history')
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snap) {
            if (snap.metadata.isFromCache) {
              return const <AccountHistoryItem>[];
            }
            return snap.docs
                .map((doc) {
                  final data = doc.data();
                  return AccountHistoryItem(
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
                })
                .where((h) => h.placeName.isNotEmpty)
                .toList();
          },
        );
  }

  Future<void> removeFavorite({
    required String userId,
    required AccountFavorite favorite,
  }) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection('favorites')
        .doc(favorite.id)
        .delete();
  }

  Future<void> addFavoriteByPlaceName({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    final normalizedName = placeName.trim();
    final docId = normalizedName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final safeDocId = docId.isEmpty ? 'favorite_place' : docId;
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection('favorites')
        .doc(safeDocId)
        .set({
          'placeName': normalizedName,
          if (placeAddress != null && placeAddress.trim().isNotEmpty)
            'placeAddress': placeAddress.trim(),
          if (placeType != null && placeType.trim().isNotEmpty)
            'placeType': placeType.trim(),
          if (lat != null) 'lat': lat,
          if (lon != null) 'lon': lon,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }
}
