import 'dart:async';

import '../../domain/usecases/watch_room.dart';
import '../state/date_navigation_state.dart';
import '../flows/room_stream_application.dart';
import '../flows/room_stream_effects.dart';
import '../runtime/meeting_planner_runtime.dart';
import '../reducers/room_stream_reducer.dart';
import '../sync/room_snapshot_reducer.dart';
import '../sync/room_sync_orchestrator.dart';
import '../sync/room_sync_reaction_policy.dart';

class RoomStreamSubscription {
  RoomStreamSubscription({
    required WatchRoom watchRoom,
    RoomStreamReducer? reducer,
    RoomStreamApplication? application,
  }) : _watchRoom = watchRoom,
       _reducer =
           reducer ??
           const RoomStreamReducer(
             RoomSnapshotReducer(),
             RoomSyncOrchestrator(RoomSyncReactionPolicy()),
           ),
       _application =
           application ?? const RoomStreamApplication(RoomStreamEffects());

  final WatchRoom _watchRoom;
  final RoomStreamReducer _reducer;
  final RoomStreamApplication _application;
  StreamSubscription? _subscription;

  void bind({
    required String roomId,
    required DateNavigationState Function() currentState,
    required String userId,
    required MeetingPlannerRuntime meetingPlanner,
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
      onApplication(_application.build(update));
    });
  }

  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
