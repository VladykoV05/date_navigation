import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/meeting_history_repository.dart';

class WatchRecentHistory {
  final MeetingHistoryRepository _repo;
  const WatchRecentHistory(this._repo);

  Stream<QuerySnapshot<Map<String, dynamic>>> call({
    required String userId,
    int limit = 10,
  }) {
    return _repo.watchRecentHistory(userId: userId, limit: limit);
  }
}
