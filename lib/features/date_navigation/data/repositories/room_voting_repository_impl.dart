import '../../../../core/error/result.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../domain/repositories/room_voting_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';

class RoomVotingRepositoryImpl implements RoomVotingRepository {
  final RoomRemoteDataSource _remote;
  RoomVotingRepositoryImpl(this._remote);

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
  }) {
    return _remote.respondToProposal(
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
    );
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
