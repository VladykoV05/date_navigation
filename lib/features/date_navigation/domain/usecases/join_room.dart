import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class JoinRoom {
  final RoomSessionRepository _repo;
  const JoinRoom(this._repo);

  Future<Result<void>> call({required String roomId, required String userId}) {
    return _repo.joinRoom(roomId: roomId, userId: userId);
  }
}
