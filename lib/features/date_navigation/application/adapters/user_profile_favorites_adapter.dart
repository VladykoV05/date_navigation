import '../../../../core/error/result.dart';
import '../../../user_profile/user_profile.dart';
import '../ports/favorites_port.dart';

class UserProfileFavoritesAdapter implements FavoritesPort {
  const UserProfileFavoritesAdapter({
    required WatchUserFavorites watchFavorites,
    required UpsertUserFavorite upsertFavorite,
    required RemoveUserFavoriteByPlace removeFavorite,
  }) : _watchFavorites = watchFavorites,
       _upsertFavorite = upsertFavorite,
       _removeFavorite = removeFavorite;

  final WatchUserFavorites _watchFavorites;
  final UpsertUserFavorite _upsertFavorite;
  final RemoveUserFavoriteByPlace _removeFavorite;

  @override
  Stream<List<UserFavorite>> watchFavorites({required String userId}) {
    return _watchFavorites(userId: userId);
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
    return _upsertFavorite(
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
    return _removeFavorite(
      userId: userId,
      placeName: placeName,
      lat: lat,
      lon: lon,
    );
  }
}
