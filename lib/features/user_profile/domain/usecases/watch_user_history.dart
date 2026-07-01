import '../entities/meeting_history_item.dart';
import '../repositories/meeting_history_repository.dart';

class WatchUserHistory {
  const WatchUserHistory(this._repo);

  final MeetingHistoryRepository _repo;

  Stream<List<MeetingHistoryItem>> call({
    required String userId,
    int limit = 10,
  }) {
    return _repo.watchRecentHistory(userId: userId, limit: limit);
  }
}
