import '../entities/account_favorite.dart';
import '../repositories/account_repository.dart';

class WatchUserFavorites {
  final AccountRepository _repo;
  const WatchUserFavorites(this._repo);

  Stream<List<AccountFavorite>> call(String userId) {
    return _repo.watchFavorites(userId);
  }
}
