import '../../../../core/error/result.dart';
import '../entities/room_snapshot.dart';
import '../value_objects/geo_coordinate.dart';

abstract interface class RoomSessionRepository {
  Future<Result<String>> createRoom(String code, {String? createdBy});
  Future<Result<String>> joinRoom({
    required String inviteCode,
    required String userId,
  });

  Future<Result<String>> createOpenRoom({
    required String hostUid,
    required int capacity,
    RoomEventSnapshot? event,
  });

  Future<Result<void>> joinOpenRoom({
    required String roomId,
    required String userId,
  });

  Future<Result<List<RoomSnapshot>>> listOpenRooms({int limit = 20});

  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required GeoCoordinate coords,
  });

  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  });

  Stream<RoomSnapshot> watchRoom(String roomId);
}
