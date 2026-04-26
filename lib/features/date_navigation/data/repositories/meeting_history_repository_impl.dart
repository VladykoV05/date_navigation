import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/meeting_history_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';

class MeetingHistoryRepositoryImpl implements MeetingHistoryRepository {
  final RoomRemoteDataSource _remote;
  MeetingHistoryRepositoryImpl(this._remote);

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _remote.watchRecentHistory(userId: userId, limit: limit);
  }
}
