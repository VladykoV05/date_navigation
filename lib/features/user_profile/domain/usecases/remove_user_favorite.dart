import '../../../../core/error/result.dart';
import '../entities/user_favorite.dart';
import '../repositories/favorites_repository.dart';

class RemoveUserFavorite {
  const RemoveUserFavorite(this._repo);

  final FavoritesRepository _repo;

  Future<Result<void>> call({
    required String userId,
    required UserFavorite favorite,
  }) {
    return _repo.removeFavorite(userId: userId, favoriteId: favorite.id);
  }
}

class RemoveUserFavoriteByPlace {
  const RemoveUserFavoriteByPlace(this._repo);

  final FavoritesRepository _repo;

  Future<Result<void>> call({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return _repo.removeFavoriteByPlace(
      userId: userId,
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }
}
