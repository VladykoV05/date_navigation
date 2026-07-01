import '../../../../core/error/result.dart';
import '../entities/user_favorite.dart';

abstract interface class FavoritesRepository {
  Stream<List<UserFavorite>> watchFavorites({
    required String userId,
    int limit = 100,
  });

  Future<Result<void>> upsertFavorite({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  });

  Future<Result<void>> removeFavorite({
    required String userId,
    required String favoriteId,
  });

  Future<Result<void>> removeFavoriteByPlace({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  });
}
