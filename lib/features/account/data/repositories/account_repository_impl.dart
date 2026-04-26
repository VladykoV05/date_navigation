import '../../domain/entities/account_favorite.dart';
import '../../domain/entities/account_history_item.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/remote/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remote;
  const AccountRepositoryImpl(this._remote);

  @override
  Stream<List<AccountFavorite>> watchFavorites(String userId) {
    return _remote.watchFavorites(userId);
  }

  @override
  Stream<List<AccountHistoryItem>> watchHistory(String userId) {
    return _remote.watchHistory(userId);
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required AccountFavorite favorite,
  }) {
    return _remote.removeFavorite(userId: userId, favorite: favorite);
  }

  @override
  Future<void> addFavoriteByPlaceName({
    required String userId,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return _remote.addFavoriteByPlaceName(
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeType: placeType,
      lat: lat,
      lon: lon,
    );
  }
}
