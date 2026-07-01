import 'dart:async';

import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../user_profile/user_profile.dart';
import '../../domain/entities/accepted_proposal_history_draft.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/usecases/propose_place.dart';
import '../../domain/usecases/respond_to_proposal.dart';
import '../../domain/usecases/vote_for_place.dart';

class RoomInteractionService {
  const RoomInteractionService({
    required VoteForPlace voteForPlace,
    required ProposePlace proposePlace,
    required RespondToProposal respondToProposal,
    required RecordMeetingHistory recordMeetingHistory,
    required AnalyticsService analytics,
  }) : _voteForPlace = voteForPlace,
       _proposePlace = proposePlace,
       _respondToProposal = respondToProposal,
       _recordMeetingHistory = recordMeetingHistory,
       _analytics = analytics;

  final VoteForPlace _voteForPlace;
  final ProposePlace _proposePlace;
  final RespondToProposal _respondToProposal;
  final RecordMeetingHistory _recordMeetingHistory;
  final AnalyticsService _analytics;

  Future<Result<void>> voteForPlace({
    required String roomId,
    required String userId,
    required String placeName,
    String? meetingFormat,
  }) async {
    final result = await _voteForPlace(
      roomId: roomId,
      userId: userId,
      placeName: placeName,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'vote_place',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    unawaited(_analytics.placeVoted());
    if (meetingFormat != null && meetingFormat.isNotEmpty) {
      unawaited(
        _analytics.placeSelectedAfterFormat(
          format: meetingFormat,
          action: 'vote',
        ),
      );
    }
    return const Ok(null);
  }

  Future<Result<void>> proposePlace({
    required String roomId,
    required ProposalAuthorRole authorRole,
    required Place place,
    String? meetingFormat,
  }) async {
    final result = await _proposePlace(
      roomId: roomId,
      placeName: place.name,
      authorRole: authorRole,
      lat: place.lat,
      lon: place.lon,
      placeAddress: place.address,
      placeType: place.type,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'propose_place',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    unawaited(_analytics.placeProposed());
    if (meetingFormat != null && meetingFormat.isNotEmpty) {
      unawaited(
        _analytics.placeSelectedAfterFormat(
          format: meetingFormat,
          action: 'propose',
        ),
      );
    }
    return const Ok(null);
  }

  Future<Result<void>> respondToProposal({
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
    String? meetingFormat,
  }) async {
    final isAccepted = decision.isAccepted;
    final result = await _respondToProposal(
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
    );
    if (result case Err(:final failure)) {
      unawaited(
        _analytics.operationFailed(
          operation: 'respond_proposal',
          failureType: failure.runtimeType.toString(),
        ),
      );
      return Err(failure);
    }
    if (result case Ok(value: final draft?)) {
      unawaited(_recordMeetingHistoryBestEffort(draft));
    }
    unawaited(_analytics.proposalResponded(accepted: isAccepted));
    if (isAccepted && meetingFormat != null && meetingFormat.isNotEmpty) {
      unawaited(
        _analytics.placeSelectedAfterFormat(
          format: meetingFormat,
          action: 'accept_proposal',
        ),
      );
    }
    return const Ok(null);
  }

  Future<void> _recordMeetingHistoryBestEffort(
    AcceptedProposalHistoryDraft draft,
  ) async {
    final result = await _recordMeetingHistory(
      roomId: draft.roomId,
      placeName: draft.placeName,
      participantIds: draft.participantIds,
      placeAddress: draft.placeAddress,
      placeType: draft.placeType,
      lat: draft.lat,
      lon: draft.lon,
    );
    if (result case Err(:final failure)) {
      AppLogger.e('Meeting history write failed', failure.message);
    }
  }
}
