import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class LeaveOpenRoom {
  final RoomSessionRepository _repo;
  const LeaveOpenRoom(this._repo);

  Future<Result<void>> call({required String roomId, required String userId}) {
    return _repo.leaveOpenRoom(roomId: roomId, userId: userId);
  }
}
