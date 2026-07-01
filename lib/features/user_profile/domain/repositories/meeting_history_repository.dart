import '../../../../core/error/result.dart';
import '../entities/meeting_history_item.dart';

abstract interface class MeetingHistoryRepository {
  Stream<List<MeetingHistoryItem>> watchRecentHistory({
    required String userId,
    int limit = 10,
  });

  Future<Result<void>> recordMeetingHistory({
    required String roomId,
    required String placeName,
    required List<String> participantIds,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
  });
}
