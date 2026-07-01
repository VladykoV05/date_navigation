import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/result.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/repositories/room_session_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';
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
  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required latlong.LatLng coords,
  }) {
    return _remote.updateLocation(
      roomId: roomId,
      userId: userId,
      coords: coords,
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
