import 'dart:async';
import 'dart:math';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_codes.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/usecases/complete_session.dart';
import '../../domain/usecases/create_room.dart';
import '../../domain/entities/room_snapshot.dart';
import '../../domain/usecases/join_room.dart';
import '../../domain/usecases/open_room_usecases.dart';

class RoomLifecycleService {
  static const int _maxCreateRoomAttempts = 12;

  RoomLifecycleService({
    required CreateRoom createRoom,
    required CompleteSession completeSession,
    required JoinRoom joinRoom,
    required CreateOpenRoom createOpenRoom,
    required JoinOpenRoom joinOpenRoom,
    required AnalyticsService analytics,
  }) : _createRoom = createRoom,
       _completeSession = completeSession,
       _joinRoom = joinRoom,
       _createOpenRoom = createOpenRoom,
       _joinOpenRoom = joinOpenRoom,
       _analytics = analytics;

  final CreateRoom _createRoom;
  final CompleteSession _completeSession;
  final JoinRoom _joinRoom;
  final CreateOpenRoom _createOpenRoom;
  final JoinOpenRoom _joinOpenRoom;
  final AnalyticsService _analytics;

  RoomAccess _access({required String roomId, required String inviteCode}) =>
      RoomAccess(roomId: roomId, inviteCode: inviteCode);

  String generateRoomCode() => (1000 + Random().nextInt(8999)).toString();

  Future<Result<RoomAccess>> createRoom({required String userId}) async {
    for (var attempt = 0; attempt < _maxCreateRoomAttempts; attempt++) {
      final inviteCode = generateRoomCode();
      final result = await _createRoom(inviteCode, createdBy: userId);
      switch (result) {
        case Err(:final failure):
          final collision = failure.message == FailureCodes.roomCodeExists;
          if (collision && attempt < _maxCreateRoomAttempts - 1) {
            continue;
          }
          unawaited(
            _analytics.operationFailed(
              operation: 'create_room',
              failureType: failure.runtimeType.toString(),
            ),
          );
          return Err(failure);
        case Ok(value: final roomId):
          unawaited(_analytics.roomCreated());
          return Ok(_access(roomId: roomId, inviteCode: inviteCode));
      }
    }
    return const Err(UnknownFailure(FailureCodes.createRoomRetry));
  }

  Future<Result<RoomAccess>> joinRoom({
    required String code,
    required String userId,
  }) async {
    final inviteCode = code.trim();
    final result = await _joinRoom(inviteCode: inviteCode, userId: userId);
    switch (result) {
      case Ok(value: final roomId):
        unawaited(_analytics.roomJoined());
        return Ok(_access(roomId: roomId, inviteCode: inviteCode));
      case Err(:final failure):
        return Err(failure);
    }
  }

  Future<Result<RoomAccess>> createOpenRoom({
    required String hostUid,
    required int capacity,
    RoomEventSnapshot? event,
  }) async {
    final result = await _createOpenRoom(
      hostUid: hostUid,
      capacity: capacity,
      event: event,
    );
    switch (result) {
      case Ok(value: final roomId):
        unawaited(_analytics.roomCreated());
        return Ok(_access(roomId: roomId, inviteCode: ''));
      case Err(:final failure):
        return Err(failure);
    }
  }

  Future<Result<RoomAccess>> joinOpenRoom({
    required String roomId,
    required String userId,
  }) async {
    final result = await _joinOpenRoom(roomId: roomId, userId: userId);
    switch (result) {
      case Ok():
        unawaited(_analytics.roomJoined());
        return Ok(_access(roomId: roomId, inviteCode: ''));
      case Err(:final failure):
        return Err(failure);
    }
  }

  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  }) async {
    final result = await _completeSession(roomId: roomId, userId: userId);
    if (result is Ok<void>) {
      unawaited(_analytics.roomClosed(reason: 'manual'));
      unawaited(_analytics.meetingCompleted(reason: 'session_completed'));
    }
    return result;
  }
}

class RoomAccess {
  const RoomAccess({required this.roomId, required this.inviteCode});

  final String roomId;
  final String inviteCode;
}
