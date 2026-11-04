import '../../../../core/error/result.dart';
import '../entities/room_snapshot.dart';
import '../repositories/room_session_repository.dart';

class CreateOpenRoom {
  const CreateOpenRoom(this._repo);

  final RoomSessionRepository _repo;

  Future<Result<String>> call({
    required String hostUid,
    required int capacity,
    RoomEventSnapshot? event,
  }) {
    return _repo.createOpenRoom(
      hostUid: hostUid,
      capacity: capacity,
      event: event,
    );
  }
}

class JoinOpenRoom {
  const JoinOpenRoom(this._repo);

  final RoomSessionRepository _repo;

  Future<Result<void>> call({required String roomId, required String userId}) {
    return _repo.joinOpenRoom(roomId: roomId, userId: userId);
  }
}

class ListOpenRooms {
  const ListOpenRooms(this._repo);

  final RoomSessionRepository _repo;

  Future<Result<List<RoomSnapshot>>> call({int limit = 20}) {
    return _repo.listOpenRooms(limit: limit);
  }
}
