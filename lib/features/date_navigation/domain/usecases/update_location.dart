import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../repositories/room_session_repository.dart';

class UpdateLocation {
  final RoomSessionRepository _repo;
  const UpdateLocation(this._repo);

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required latlong.LatLng coords,
  }) {
    return _repo.updateLocation(roomId: roomId, userId: userId, coords: coords);
  }
}
