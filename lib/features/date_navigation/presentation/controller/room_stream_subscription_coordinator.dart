import 'dart:async';

import '../../domain/usecases/watch_room.dart';
import '../state/date_navigation_state.dart';
import 'flows/room_stream_application_coordinator.dart';
import 'flows/room_stream_effects_coordinator.dart';
import 'meeting_planner_coordinator.dart';
import 'reducers/room_stream_reducer.dart';
import 'room_sync_coordinator.dart';
import 'room_sync_orchestrator.dart';
import 'room_sync_reaction_coordinator.dart';

class RoomStreamSubscriptionCoordinator {
  RoomStreamSubscriptionCoordinator({
    required WatchRoom watchRoom,
    RoomStreamReducer? reducer,
    RoomStreamApplicationCoordinator? applicationCoordinator,
  }) : _watchRoom = watchRoom,
       _reducer =
           reducer ??
           const RoomStreamReducer(
             RoomSyncCoordinator(),
             RoomSyncOrchestrator(RoomSyncReactionCoordinator()),
           ),
       _applicationCoordinator =
           applicationCoordinator ??
           const RoomStreamApplicationCoordinator(
             RoomStreamEffectsCoordinator(),
           );

  final WatchRoom _watchRoom;
  final RoomStreamReducer _reducer;
  final RoomStreamApplicationCoordinator _applicationCoordinator;
  StreamSubscription? _subscription;

  void bind({
    required String roomId,
    required DateNavigationState Function() currentState,
    required String userId,
    required MeetingPlannerCoordinator meetingPlanner,
    required Duration snapshotFreshFor,
    required void Function(RoomStreamApplicationResult application)
    onApplication,
  }) {
    _subscription?.cancel();
    _subscription = _watchRoom(roomId).listen((roomSnapshot) {
      final update = _reducer.reduce(
        currentState: currentState(),
        roomSnapshot: roomSnapshot,
        userId: userId,
        meetingPlanner: meetingPlanner,
        snapshotFreshFor: snapshotFreshFor,
        now: DateTime.now(),
      );
      onApplication(_applicationCoordinator.build(update));
    });
  }

  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
