import '../../domain/entities/meeting_history_item.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/meeting_history_repository.dart';
import '../datasources/remote/user_meeting_history_remote_data_source.dart';
import 'user_profile_firestore_guard.dart';

class MeetingHistoryRepositoryImpl implements MeetingHistoryRepository {
  const MeetingHistoryRepositoryImpl(this._remote);

  final UserMeetingHistoryRemoteDataSource _remote;

  @override
  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  }) {
    return _remote.watchRecentHistory(userId: userId, limit: limit);
  }

  @override
  Future<Result<void>> recordMeetingHistory({
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  }) {
    return runUserProfileVoid(
      () => _remote.recordMeetingHistory(
        roomId: roomId,
        placeName: placeName,
        participantIds: participantIds,
        placeAddress: placeAddress,
        placeType: placeType,
        lat: lat,
        lon: lon,
      ),
      fallback: 'Не удалось сохранить историю встречи',
    );
  }
}
