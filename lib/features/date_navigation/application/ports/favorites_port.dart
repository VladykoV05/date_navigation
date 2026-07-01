import '../../../../core/error/result.dart';
import '../../../user_profile/user_profile.dart';

abstract class FavoritesPort {
  Stream<List<UserFavorite>> watchFavorites({required String userId});

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
    required String placeName,
    double? lat,
    double? lon,
  });
}
