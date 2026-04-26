import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/result.dart';
import '../../domain/repositories/user_favorites_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';

class UserFavoritesRepositoryImpl implements UserFavoritesRepository {
  final RoomRemoteDataSource _remote;
  UserFavoritesRepositoryImpl(this._remote);

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchFavorites({
    required String userId,
    int limit = 100,
  }) {
    return _remote.watchFavorites(userId: userId, limit: limit);
  }

  @override
  Future<Result<void>> upsertFavorite({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _remote.upsertFavorite(
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }

  @override
  Future<Result<void>> removeFavorite({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return _remote.removeFavorite(
      userId: userId,
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }
}
