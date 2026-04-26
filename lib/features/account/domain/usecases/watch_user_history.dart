import '../entities/account_history_item.dart';
import '../repositories/account_repository.dart';

class WatchUserHistory {
  final AccountRepository _repo;
  const WatchUserHistory(this._repo);

  Stream<List<AccountHistoryItem>> call(String userId) {
    return _repo.watchHistory(userId);
  }
}
