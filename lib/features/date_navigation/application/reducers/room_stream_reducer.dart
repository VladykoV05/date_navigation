import '../runtime/meeting_planner_runtime.dart';
import '../sync/room_snapshot_reducer.dart';
import '../sync/room_sync_orchestrator.dart';
import '../state/date_navigation_state.dart';
import '../../domain/entities/room_snapshot.dart';

class RoomStreamUpdate {
  const RoomStreamUpdate({
    required this.outcome,
    required this.plan,
    required this.shouldRecoverMissingMeeting,
  });

  final RoomSyncOutcome outcome;
  final RoomSyncPlan plan;
  final bool shouldRecoverMissingMeeting;
}

class RoomStreamReducer {
  const RoomStreamReducer(this._roomSync, this._roomSyncOrchestrator);

  final RoomSnapshotReducer _roomSync;
  final RoomSyncOrchestrator _roomSyncOrchestrator;

  RoomStreamUpdate reduce({
    required DateNavigationState currentState,
    required RoomSnapshot roomSnapshot,
    required String userId,
    required MeetingPlannerRuntime meetingPlanner,
    required Duration snapshotFreshFor,
    required DateTime now,
  }) {
    final outcome = _roomSync.buildOutcome(
      currentState: currentState,
      roomSnapshot: roomSnapshot,
      userId: userId,
      meetingPlanner: meetingPlanner,
    );
    final plan = _roomSyncOrchestrator.buildPlan(
      previousState: currentState,
      outcome: outcome,
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );
    final nextState = plan.nextState;
    final shouldRecoverMissingMeeting =
        nextState.meeting.selectedMeetingFormat != null &&
        !nextState.room.isClosed &&
        nextState.room.point1 != null &&
        nextState.room.point2 != null &&
        nextState.meeting.centerPoint == null &&
        !nextState.ui.isCalculatingMeeting;
    return RoomStreamUpdate(
      outcome: outcome,
      plan: plan,
      shouldRecoverMissingMeeting: shouldRecoverMissingMeeting,
    );
  }
}
