import '../../../../core/error/result.dart';
import '../entities/date_vibe.dart';
import '../entities/voting_decisions.dart';
import '../repositories/room_voting_repository.dart';

class SaveMeetingFormat {
  const SaveMeetingFormat(this._repo);

  final RoomVotingRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required Set<MeetingFormat> formats,
  }) {
    return _repo.saveMeetingFormats(
      roomId: roomId,
      userId: userId,
      formats: formats
          .map((format) => format.wireValue)
          .toList(growable: false),
    );
  }
}

class ConfirmMeetingFormat {
  const ConfirmMeetingFormat(this._repo);

  final RoomVotingRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required MeetingFormat format,
  }) {
    return _repo.saveSelectedMeetingFormat(
      roomId: roomId,
      userId: userId,
      format: format.wireValue,
    );
  }
}

class RequestMeetingRevote {
  const RequestMeetingRevote(this._repo);

  final RoomVotingRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required Set<MeetingFormat> formats,
  }) {
    return _repo.requestMeetingRevote(
      roomId: roomId,
      userId: userId,
      formats: formats.map((format) => format.wireValue).toList(growable: false),
    );
  }
}

class RespondMeetingRevote {
  const RespondMeetingRevote(this._repo);

  final RoomVotingRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required MeetingRevoteResponseDecision decision,
  }) {
    return _repo.respondMeetingRevote(
      roomId: roomId,
      userId: userId,
      decision: decision,
    );
  }
}
