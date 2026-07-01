import '../state/date_navigation_state.dart';
import './room_snapshot_reducer.dart';
import './room_sync_reaction_policy.dart';

class RoomSyncPlan {
  const RoomSyncPlan({
    required this.nextState,
    required this.trackMatchedFormat,
    required this.matchedFormatWireValue,
    required this.startMeetingSearch,
    required this.syncScenarioForFinalChoice,
    required this.syncFetchedRadiusFromSnapshot,
    required this.resetPlannerOnPointsChanged,
    required this.reactionAction,
  });

  final DateNavigationState nextState;
  final bool trackMatchedFormat;
  final String? matchedFormatWireValue;
  final bool startMeetingSearch;
  final bool syncScenarioForFinalChoice;
  final bool syncFetchedRadiusFromSnapshot;
  final bool resetPlannerOnPointsChanged;
  final RoomSyncAction reactionAction;
}

class RoomSyncOrchestrator {
  const RoomSyncOrchestrator(this._reactionPolicy);

  final RoomSyncReactionPolicy _reactionPolicy;

  RoomSyncPlan buildPlan({
    required DateNavigationState previousState,
    required RoomSyncOutcome outcome,
    required Duration snapshotFreshFor,
    required DateTime now,
  }) {
    final nextState = outcome.nextState;
    final previousMatched = previousState.meeting.selectedMeetingFormat;
    final matchedJustNow =
        previousMatched == null &&
        nextState.meeting.selectedMeetingFormat != null;
    final matchedFormatChanged =
        previousMatched != null &&
        nextState.meeting.selectedMeetingFormat != null &&
        previousMatched != nextState.meeting.selectedMeetingFormat;
    final canStartMeetingSearch =
        (matchedJustNow || matchedFormatChanged) &&
        !outcome.venueLocked &&
        nextState.room.point1 != null &&
        nextState.room.point2 != null;
    final reactionAction = _reactionPolicy.decide(
      outcome: outcome,
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );
    final effectiveReactionAction = canStartMeetingSearch
        ? RoomSyncAction.none
        : reactionAction;

    return RoomSyncPlan(
      nextState: nextState,
      trackMatchedFormat: matchedJustNow || matchedFormatChanged,
      matchedFormatWireValue:
          nextState.meeting.selectedMeetingFormat?.wireValue,
      startMeetingSearch: canStartMeetingSearch,
      syncScenarioForFinalChoice: outcome.venueLocked,
      syncFetchedRadiusFromSnapshot:
          !outcome.venueLocked &&
          outcome.hasSnapshot &&
          outcome.snapshotMatchesFormat,
      resetPlannerOnPointsChanged: outcome.pointsChanged,
      reactionAction: effectiveReactionAction,
    );
  }
}
