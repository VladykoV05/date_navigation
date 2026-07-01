import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../user_profile/domain/usecases/record_meeting_history.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/repositories/room_voting_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';
import '../datasources/remote/room_voting_remote_data_source.dart';

class RoomVotingRepositoryImpl implements RoomVotingRepository {
  final RoomRemoteDataSource _remote;
  final RecordMeetingHistory _recordMeetingHistory;

  RoomVotingRepositoryImpl(this._remote, this._recordMeetingHistory);

  @override
  Future<Result<void>> voteForPlace({
    required String roomId,
    required String userId,
    required String placeName,
  }) {
    return _remote.voteForPlace(
      roomId: roomId,
      userId: userId,
      placeName: placeName,
    );
  }

  @override
  Future<Result<void>> proposePlace({
    required String roomId,
    required String placeName,
    required ProposalAuthorRole authorRole,
    required double lat,
    required double lon,
    String? placeAddress,
    String? placeType,
  }) {
    return _remote.proposePlace(
      roomId: roomId,
      placeName: placeName,
      authorRole: authorRole,
      lat: lat,
      lon: lon,
      placeAddress: placeAddress,
      placeType: placeType,
    );
  }

  @override
  Future<Result<void>> respondToProposal({
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  }) async {
    final response = await _remote.respondToProposalForHistory(
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
    );
    return switch (response) {
      Err(:final failure) => Err(failure),
      Ok(value: null) => const Ok(null),
      Ok(value: final draft?) => await _recordMeetingHistoryBestEffort(draft),
    };
  }

  Future<Result<void>> _recordMeetingHistoryBestEffort(
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
    return const Ok(null);
  }

  @override
  Future<Result<void>> saveSelectedScenario({
    required String roomId,
    required Map<String, dynamic> scenario,
    required String selectedByUserId,
  }) {
    return _remote.saveSelectedScenario(
      roomId: roomId,
      scenario: scenario,
      selectedByUserId: selectedByUserId,
    );
  }

  @override
  Future<Result<void>> saveMeetingFormats({
    required String roomId,
    required String userId,
    required List<String> formats,
  }) {
    return _remote.saveMeetingFormats(
      roomId: roomId,
      userId: userId,
      formats: formats,
    );
  }

  @override
  Future<Result<void>> requestMeetingRevote({
    required String roomId,
    required String userId,
    required List<String> formats,
  }) {
    return _remote.requestMeetingRevote(
      roomId: roomId,
      userId: userId,
      formats: formats,
    );
  }

  @override
  Future<Result<void>> respondMeetingRevote({
    required String roomId,
    required String userId,
    required MeetingRevoteResponseDecision decision,
  }) {
    return _remote.respondMeetingRevote(
      roomId: roomId,
      userId: userId,
      decision: decision,
    );
  }

  @override
  Future<Result<void>> saveSelectedMeetingFormat({
    required String roomId,
    required String userId,
    required String format,
  }) {
    return _remote.saveSelectedMeetingFormat(
      roomId: roomId,
      userId: userId,
      format: format,
    );
  }

  @override
  Future<Result<void>> saveSearchRadius({
    required String roomId,
    required String userId,
    required int radius,
  }) {
    return _remote.saveSearchRadius(
      roomId: roomId,
      userId: userId,
      radius: radius,
    );
  }
}
