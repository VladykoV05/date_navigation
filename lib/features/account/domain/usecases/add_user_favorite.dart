import '../repositories/account_repository.dart';

class AddUserFavorite {
  const AddUserFavorite(this._repo);

  final AccountRepository _repo;

  Future<void> call({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _repo.addFavoriteByPlaceName(
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }
}
