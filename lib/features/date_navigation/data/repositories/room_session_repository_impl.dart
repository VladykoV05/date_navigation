import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
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
    final controller = StreamController<RoomSnapshot>();
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? roomSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? participantsSub;
    DocumentSnapshot<Map<String, dynamic>>? lastRoom;
    QuerySnapshot<Map<String, dynamic>>? lastParticipants;
    var participantsFailed = false;

    void emit() {
      final room = lastRoom;
      final participants = lastParticipants;
      if (room == null) return;
      if (participants == null && !participantsFailed) return;
      final data = room.data();
      if (!room.exists || data == null) return;
      final participantDocs = participants == null
          ? const <String, Map<String, dynamic>>{}
          : <String, Map<String, dynamic>>{
              for (final doc in participants.docs) doc.id: doc.data(),
            };
      final snapshot = _roomSnapshotMapper.fromMap(
        room.id,
        data,
        participantDocs: participantDocs,
      );
      if (!controller.isClosed) controller.add(snapshot);
    }

    controller.onListen = () {
      roomSub = _remote.watchRoom(roomId).listen((doc) {
        lastRoom = doc;
        emit();
      }, onError: controller.addError);
      participantsSub = _remote
          .watchParticipants(roomId)
          .listen(
            (snapshot) {
              participantsFailed = false;
              lastParticipants = snapshot;
              emit();
            },
            onError: (Object error, StackTrace stack) {
              AppLogger.e('Participants stream failed', error, stack);
              participantsFailed = true;
              emit();
            },
          );
    };
    controller.onCancel = () async {
      await roomSub?.cancel();
      await participantsSub?.cancel();
    };
    return controller.stream;
  }
}
