import '../../domain/entities/user_favorite.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/remote/user_favorites_remote_data_source.dart';
import 'user_profile_firestore_guard.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._remote);

  final UserFavoritesRemoteDataSource _remote;

  @override
  Stream<List<UserFavorite>> watchFavorites({
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
    return runUserProfileVoid(
      () => _remote.upsertFavorite(
        userId: userId,
        placeName: placeName,
        placeAddress: placeAddress,
        placeType: placeType,
        lat: lat,
        lon: lon,
      ),
      fallback: 'Не удалось сохранить в избранное',
    );
  }

  @override
  Future<Result<void>> removeFavorite({
    required String userId,
    required String favoriteId,
  }) {
    return runUserProfileVoid(
      () => _remote.removeFavorite(userId: userId, favoriteId: favoriteId),
      fallback: 'Не удалось удалить из избранного',
    );
  }

  @override
  Future<Result<void>> removeFavoriteByPlace({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return runUserProfileVoid(
      () => _remote.removeFavoriteByPlace(
        userId: userId,
        placeName: placeName,
        lat: lat,
        lon: lon,
      ),
      fallback: 'Не удалось удалить из избранного',
    );
  }
}
