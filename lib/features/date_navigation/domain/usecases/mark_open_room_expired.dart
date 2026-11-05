import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class MarkOpenRoomExpired {
  final RoomSessionRepository _repo;
  const MarkOpenRoomExpired(this._repo);

  Future<Result<void>> call({required String roomId}) {
    return _repo.markOpenRoomExpired(roomId: roomId);
  }
}
