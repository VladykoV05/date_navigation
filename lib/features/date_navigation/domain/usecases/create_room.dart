import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class CreateRoom {
  final RoomSessionRepository _repo;
  const CreateRoom(this._repo);

  Future<Result<String>> call(String code, {required String createdBy}) {
    return _repo.createRoom(code, createdBy: createdBy);
  }
}
