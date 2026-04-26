import '../meeting_planner_coordinator.dart';
import '../room_sync_coordinator.dart';
import '../room_sync_orchestrator.dart';
import '../../state/date_navigation_state.dart';

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

  final RoomSyncCoordinator _roomSync;
  final RoomSyncOrchestrator _roomSyncOrchestrator;

  RoomStreamUpdate reduce({
    required DateNavigationState currentState,
    required Map<String, dynamic> roomData,
    required String userId,
    required MeetingPlannerCoordinator meetingPlanner,
    required Duration snapshotFreshFor,
    required DateTime now,
  }) {
    final outcome = _roomSync.buildOutcome(
      currentState: currentState,
      roomData: roomData,
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
        nextState.selectedMeetingFormat != null &&
        !nextState.roomSession.isClosed &&
        nextState.roomSession.point1 != null &&
        nextState.roomSession.point2 != null &&
        nextState.centerPoint == null &&
        !nextState.isCalculatingMeeting;
    return RoomStreamUpdate(
      outcome: outcome,
      plan: plan,
      shouldRecoverMissingMeeting: shouldRecoverMissingMeeting,
    );
  }
}
