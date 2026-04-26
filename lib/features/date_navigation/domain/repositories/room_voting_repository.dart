import '../../../../core/error/result.dart';
import '../entities/voting_decisions.dart';

abstract interface class RoomVotingRepository {
  Future<Result<void>> voteForPlace({
    required String roomId,
    required String userId,
    required String placeName,
  });

  Future<Result<void>> proposePlace({
    required String roomId,
    required String placeName,
    required ProposalAuthorRole authorRole,
    required double lat,
    required double lon,
    String? placeAddress,
    String? placeType,
  });

  Future<Result<void>> respondToProposal({
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  });

  Future<Result<void>> saveSelectedScenario({
    required String roomId,
    required Map<String, dynamic> scenario,
    required String selectedByUserId,
  });

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
