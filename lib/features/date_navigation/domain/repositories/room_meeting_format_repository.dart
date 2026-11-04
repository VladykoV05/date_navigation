import '../../../../core/error/result.dart';
import '../entities/voting_decisions.dart';

abstract interface class RoomMeetingFormatRepository {
  Future<Result<void>> saveMeetingFormats({
    required String roomId,
    required String userId,
    required List<String> formats,
  });

  Future<Result<void>> requestMeetingRevote({
    required String roomId,
    required String userId,
    required List<String> formats,
  });

  Future<Result<void>> respondMeetingRevote({
    required String roomId,
    required String userId,
    required MeetingRevoteResponseDecision decision,
  });

  Future<Result<void>> saveSelectedMeetingFormat({
    required String roomId,
    required String userId,
    required String format,
  });

  Future<Result<void>> saveSearchRadius({
    required String roomId,
    required String userId,
    required int radius,
  });
}
