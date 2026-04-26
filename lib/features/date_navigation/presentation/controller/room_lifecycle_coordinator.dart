import 'dart:async';
import 'dart:math';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/usecases/complete_session.dart';
import '../../domain/usecases/create_room.dart';
import '../../domain/usecases/join_room.dart';

class RoomLifecycleCoordinator {
  static const int _maxCreateRoomAttempts = 12;

  RoomLifecycleCoordinator({
    required CreateRoom createRoom,
    required CompleteSession completeSession,
    required JoinRoom joinRoom,
    required AnalyticsService analytics,
  }) : _createRoom = createRoom,
       _completeSession = completeSession,
       _joinRoom = joinRoom,
       _analytics = analytics;

  final CreateRoom _createRoom;
  final CompleteSession _completeSession;
  final JoinRoom _joinRoom;
  final AnalyticsService _analytics;

  String generateRoomCode() => (1000 + Random().nextInt(8999)).toString();

  Future<Result<String>> createRoom({required String userId}) async {
    for (var attempt = 0; attempt < _maxCreateRoomAttempts; attempt++) {
      final code = generateRoomCode();
      final result = await _createRoom(code, createdBy: userId);
      switch (result) {
        case Err(:final failure):
          final collision = failure.message.contains(
            'Комната с таким кодом уже существует',
          );
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
        case Ok():
          unawaited(_analytics.roomCreated());
          return Ok(code);
      }
    }
    return const Err(
      UnknownFailure('Не удалось создать комнату: попробуй еще раз'),
    );
  }

  Future<Result<void>> joinRoom({
    required String code,
    required String userId,
  }) async {
    final result = await _joinRoom(roomId: code, userId: userId);
    if (result is Ok<void>) {
      unawaited(_analytics.roomJoined());
    }
    return result;
  }

  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  }) async {
    final result = await _completeSession(roomId: roomId, userId: userId);
    if (result is Ok<void>) {
      unawaited(_analytics.roomClosed(reason: 'manual'));
    }
    return result;
  }
}
