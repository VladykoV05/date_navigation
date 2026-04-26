import '../../../../core/error/result.dart';
import '../repositories/user_favorites_repository.dart';

class UpsertFavorite {
  final UserFavoritesRepository _repo;
  const UpsertFavorite(this._repo);

  Future<Result<void>> call({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _repo.upsertFavorite(
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }
}
