import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';
import '../value_objects/geo_coordinate.dart';

class UpdateLocation {
  final RoomSessionRepository _repo;
  const UpdateLocation(this._repo);

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required GeoCoordinate coords,
  }) {
    return _repo.updateLocation(roomId: roomId, userId: userId, coords: coords);
  }
}
