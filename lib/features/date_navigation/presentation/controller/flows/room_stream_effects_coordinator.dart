import '../reducers/room_stream_reducer.dart';
import '../room_sync_reaction_coordinator.dart';

class RoomStreamEffectsDecision {
  const RoomStreamEffectsDecision({
    required this.trackMatchedFormat,
    required this.matchedFormatWireValue,
    required this.startMeetingSearch,
    required this.recoverMissingMeeting,
    required this.syncScenarioForFinalChoice,
    required this.syncFetchedRadiusFromSnapshot,
    required this.resetPlannerOnPointsChanged,
    required this.reactionAction,
  });

  final bool trackMatchedFormat;
  final String? matchedFormatWireValue;
  final bool startMeetingSearch;
  final bool recoverMissingMeeting;
  final bool syncScenarioForFinalChoice;
  final bool syncFetchedRadiusFromSnapshot;
  final bool resetPlannerOnPointsChanged;
  final RoomSyncAction reactionAction;
}

class RoomStreamEffectsCoordinator {
  const RoomStreamEffectsCoordinator();

  RoomStreamEffectsDecision buildDecision(RoomStreamUpdate update) {
    final plan = update.plan;
    return RoomStreamEffectsDecision(
      trackMatchedFormat: plan.trackMatchedFormat,
      matchedFormatWireValue: plan.matchedFormatWireValue,
      startMeetingSearch: plan.startMeetingSearch,
      recoverMissingMeeting: update.shouldRecoverMissingMeeting,
      syncScenarioForFinalChoice: plan.syncScenarioForFinalChoice,
      syncFetchedRadiusFromSnapshot: plan.syncFetchedRadiusFromSnapshot,
      resetPlannerOnPointsChanged: plan.resetPlannerOnPointsChanged,
      reactionAction: plan.reactionAction,
    );
  }
}
