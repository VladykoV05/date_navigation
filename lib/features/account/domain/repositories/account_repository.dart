import '../entities/account_favorite.dart';
import '../entities/account_history_item.dart';

abstract interface class AccountRepository {
  Stream<List<AccountFavorite>> watchFavorites(String userId);
  Stream<List<AccountHistoryItem>> watchHistory(String userId);

  Future<void> removeFavorite({
    required String userId,
    required AccountFavorite favorite,
  });

  Future<void> addFavoriteByPlaceName({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  });
}
