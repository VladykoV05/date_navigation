import '../../../../core/error/result.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/repositories/room_session_repository.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../datasources/remote/room_remote_data_source.dart';
import '../mappers/geo_coordinate_mapper.dart';
import '../mappers/room_snapshot_mapper.dart';

class RoomSessionRepositoryImpl implements RoomSessionRepository {
  final RoomRemoteDataSource _remote;
  final RoomSnapshotMapper _roomSnapshotMapper;
  RoomSessionRepositoryImpl(
    this._remote, {
    RoomSnapshotMapper roomSnapshotMapper = const RoomSnapshotMapper(),
  }) : _roomSnapshotMapper = roomSnapshotMapper;

  @override
  Future<Result<String>> createRoom(String code, {String? createdBy}) {
    return _remote.createRoom(code, createdBy: createdBy);
  }

  @override
  Future<Result<String>> joinRoom({
    required String inviteCode,
    required String userId,
  }) {
    return _remote.joinRoom(inviteCode: inviteCode, userId: userId);
  }

  @override
  Future<Result<String>> createOpenRoom({
    required String hostUid,
    required int capacity,
    RoomEventSnapshot? event,
  }) {
    return _remote.createOpenRoom(
      hostUid: hostUid,
      capacity: capacity,
      event: event == null ? null : RoomSnapshotMapper.eventToWire(event),
    );
  }

  @override
  Future<Result<void>> joinOpenRoom({
    required String roomId,
    required String userId,
  }) {
    return _remote.joinOpenRoom(roomId: roomId, userId: userId);
  }

  @override
  Future<Result<List<RoomSnapshot>>> listOpenRooms({int limit = 20}) async {
    final result = await _remote.listOpenRooms(limit: limit);
    final now = DateTime.now();
    return switch (result) {
      Err(:final failure) => Err(failure),
      Ok(:final value) => Ok(
        value
            .map((doc) => _roomSnapshotMapper.fromMap(doc.id, doc.data()))
            .where(
              (room) => room.expiresAt == null || room.expiresAt!.isAfter(now),
            )
            .toList(growable: false),
      ),
    };
  }

  @override
  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required GeoCoordinate coords,
  }) {
    return _remote.updateLocation(
      roomId: roomId,
      userId: userId,
      coords: GeoCoordinateMapper.toLatLng(coords),
    );
  }

  @override
  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  }) {
    return _remote.completeSession(roomId: roomId, userId: userId);
  }

  @override
  Stream<RoomSnapshot> watchRoom(String roomId) {
    return _remote
        .watchRoom(roomId)
        .map(_roomSnapshotMapper.fromDocument)
        .where((snapshot) => snapshot != null)
        .cast<RoomSnapshot>();
  }
}
