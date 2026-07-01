import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/favorite_place_key.dart';
import '../../../domain/entities/user_favorite.dart';
import '../../mappers/user_favorite_mapper.dart';

class UserFavoritesRemoteDataSource {
  const UserFavoritesRemoteDataSource(this._firestore);

  static const _usersCollection = 'users';
  static const _favoritesCollection = 'favorites';

  final FirebaseFirestore _firestore;

  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  }) {
    return _userCollection(userId)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(UserFavoriteMapper.fromDoc)
              .where((favorite) => favorite.name.isNotEmpty)
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
    return _userCollection(userId).doc(favoriteId).delete();
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

  CollectionReference<Map<String, dynamic>> _userCollection(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_favoritesCollection);
  }

  static String favoriteDocId({
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return FavoritePlaceKey.fromPlace(
      placeName: placeName,
      lat: lat,
      lon: lon,
    ).docId;
  }
}
