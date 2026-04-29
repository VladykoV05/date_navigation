import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class JoinRoom {
  final RoomSessionRepository _repo;
  const JoinRoom(this._repo);

  Future<Result<String>> call({
    required String inviteCode,
    required String userId,
  }) {
    return _repo.joinRoom(inviteCode: inviteCode, userId: userId);
  }
}
