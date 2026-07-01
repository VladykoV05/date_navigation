import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class CompleteSession {
  final RoomSessionRepository _repo;
  const CompleteSession(this._repo);

  Future<Result<void>> call({required String roomId, required String userId}) {
    return _repo.completeSession(roomId: roomId, userId: userId);
  }
}
