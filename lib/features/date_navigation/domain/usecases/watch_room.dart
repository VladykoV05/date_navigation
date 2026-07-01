import '../entities/room_snapshot.dart';
import '../repositories/room_session_repository.dart';

class WatchRoom {
  final RoomSessionRepository _repo;
  const WatchRoom(this._repo);

  Stream<RoomSnapshot> call(String roomId) {
    return _repo.watchRoom(roomId);
  }
}
