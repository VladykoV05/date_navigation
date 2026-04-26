import '../../../../core/error/result.dart';
import '../repositories/user_favorites_repository.dart';

class RemoveFavorite {
  final UserFavoritesRepository _repo;
  const RemoveFavorite(this._repo);

  Future<Result<void>> call({
    required String userId,
    required String placeName,
    double? lat,
    double? lon,
  }) {
    return _repo.removeFavorite(
      userId: userId,
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }
}
