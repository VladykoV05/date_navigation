import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../entities/room_snapshot.dart';

abstract interface class RoomSessionRepository {
  Future<Result<String>> createRoom(String code, {String? createdBy});
  Future<Result<String>> joinRoom({
    required String inviteCode,
    required String userId,
  });

  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required latlong.LatLng coords,
  });

  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  });

  Stream<RoomSnapshot> watchRoom(String roomId);
}
