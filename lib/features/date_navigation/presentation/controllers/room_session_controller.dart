import 'dart:async';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../application/runtime/meeting_planner_runtime.dart';
import '../../application/state_transitions/room_session_state_transitions.dart';
import '../../application/services/room_lifecycle_service.dart';
import '../../application/state/date_navigation_state.dart';

typedef DateNavigationStateReader = DateNavigationState Function();
typedef DateNavigationStateWriter = void Function(DateNavigationState state);
typedef UserIdRequirement = String? Function(String operation);
typedef FailureWriter = void Function(Failure failure, String operation);
typedef RoomSubscriptionStarter = void Function(String roomId);

class RoomSessionController {
  RoomSessionController({
    required RoomLifecycleService roomLifecycle,
    required RoomSessionStateTransitions roomActions,
    required MeetingPlannerRuntime meetingPlanner,
    required DateNavigationStateReader readState,
    required DateNavigationStateWriter writeState,
    required UserIdRequirement requireUserId,
    required FailureWriter setFailure,
    required void Function() clearFailure,
    required void Function(bool value) setRoomActionLoading,
    required Future<void> Function() cancelRoomSubscription,
    required RoomSubscriptionStarter subscribeToRoom,
  }) : _roomLifecycle = roomLifecycle,
       _roomActions = roomActions,
       _meetingPlanner = meetingPlanner,
       _readState = readState,
       _writeState = writeState,
       _requireUserId = requireUserId,
       _setFailure = setFailure,
       _clearFailure = clearFailure,
       _setRoomActionLoading = setRoomActionLoading,
       _cancelRoomSubscription = cancelRoomSubscription,
       _subscribeToRoom = subscribeToRoom;

  final RoomLifecycleService _roomLifecycle;
  final RoomSessionStateTransitions _roomActions;
  final MeetingPlannerRuntime _meetingPlanner;
  final DateNavigationStateReader _readState;
  final DateNavigationStateWriter _writeState;
  final UserIdRequirement _requireUserId;
  final FailureWriter _setFailure;
  final void Function() _clearFailure;
  final void Function(bool value) _setRoomActionLoading;
  final Future<void> Function() _cancelRoomSubscription;
  final RoomSubscriptionStarter _subscribeToRoom;

  Future<void> createRoom() async {
    final uid = _requireUserId('room');
    if (uid == null) return;
    _setRoomActionLoading(true);
    _clearFailure();
    final res = await _roomLifecycle.createRoom(userId: uid);
    switch (res) {
      case Err(:final failure):
        _setRoomActionLoading(false);
        _setFailure(failure, 'room');
      case Ok(value: final access):
        _writeState(
          _roomActions.afterCreateSuccess(
            _readState(),
            roomId: access.roomId,
            inviteCode: access.inviteCode,
          ),
        );
        _subscribeToRoom(access.roomId);
    }
  }

  void joinRoom(String code) {
    if (code.isEmpty) return;
    unawaited(_joinRoomInternal(code));
  }

  Future<void> _joinRoomInternal(String code) async {
    final uid = _requireUserId('room');
    if (uid == null) return;
    _setRoomActionLoading(true);
    _clearFailure();
    final res = await _roomLifecycle.joinRoom(code: code, userId: uid);
    switch (res) {
      case Err(:final failure):
        _setRoomActionLoading(false);
        _setFailure(failure, 'room');
      case Ok(value: final access):
        _writeState(
          _roomActions.afterJoinSuccess(
            _readState(),
            roomId: access.roomId,
            inviteCode: access.inviteCode,
          ),
        );
        _subscribeToRoom(access.roomId);
    }
  }

  Future<void> completeSession() async {
    final uid = _requireUserId('room');
    if (uid == null) return;
    final state = _readState();
    final completeValidationFailure = _roomActions.validateCompleteSession(
      state,
    );
    if (completeValidationFailure != null) {
      _setFailure(completeValidationFailure, 'room');
      return;
    }
    final roomId = state.room.roomId;
    if (roomId == null || roomId.isEmpty) return;
    if (state.room.isClosed) return;
    _setRoomActionLoading(true);
    _clearFailure();
    final res = await _roomLifecycle.completeSession(
      roomId: roomId,
      userId: uid,
    );
    _setRoomActionLoading(false);
    if (res case Err(:final failure)) {
      _setFailure(failure, 'room');
    } else {
      _clearFailure();
    }
  }

  Future<void> startNewRoom() async {
    leaveRoom();
    await createRoom();
  }

  void leaveRoom() {
    unawaited(_cancelRoomSubscription());
    _meetingPlanner.resetAll();
    _writeState(_roomActions.afterLeaveRoom(_readState()));
  }
}
