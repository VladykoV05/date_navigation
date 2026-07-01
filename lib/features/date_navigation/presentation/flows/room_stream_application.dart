import 'package:latlong2/latlong.dart' as latlong;

import '../state/date_navigation_state.dart';
import '../reducers/room_stream_reducer.dart';
import '../sync/room_sync_reaction_policy.dart';
import './room_stream_effects.dart';

class RoomStreamApplicationResult {
  const RoomStreamApplicationResult({
    required this.nextState,
    required this.matchedFormatToTrack,
    required this.shouldStartMeetingSearch,
    required this.shouldRecoverMissingMeeting,
    required this.shouldSyncScenarioForFinalChoice,
    required this.snapshotRadiusToSync,
    required this.shouldResetPlannerOnPointsChanged,
    required this.shouldStopCalculating,
    required this.shouldCalculateAsCreator,
    required this.shouldCalculateWithPartnerFallback,
    required this.fallbackPoint1,
    required this.fallbackPoint2,
  });

  final DateNavigationState nextState;
  final String? matchedFormatToTrack;
  final bool shouldStartMeetingSearch;
  final bool shouldRecoverMissingMeeting;
  final bool shouldSyncScenarioForFinalChoice;
  final int? snapshotRadiusToSync;
  final bool shouldResetPlannerOnPointsChanged;
  final bool shouldStopCalculating;
  final bool shouldCalculateAsCreator;
  final bool shouldCalculateWithPartnerFallback;
  final latlong.LatLng? fallbackPoint1;
  final latlong.LatLng? fallbackPoint2;
}

class RoomStreamApplication {
  const RoomStreamApplication(this._effects);

  final RoomStreamEffects _effects;

  RoomStreamApplicationResult build(RoomStreamUpdate update) {
    final outcome = update.outcome;
    final effects = _effects.buildDecision(update);
    final shouldCalculateWithPartnerFallback =
        effects.reactionAction == RoomSyncAction.calculateWithPartnerFallback &&
        outcome.point1 != null &&
        outcome.point2 != null;
    return RoomStreamApplicationResult(
      nextState: update.plan.nextState,
      matchedFormatToTrack: effects.trackMatchedFormat
          ? effects.matchedFormatWireValue
          : null,
      shouldStartMeetingSearch: effects.startMeetingSearch,
      shouldRecoverMissingMeeting: effects.recoverMissingMeeting,
      shouldSyncScenarioForFinalChoice: effects.syncScenarioForFinalChoice,
      snapshotRadiusToSync: effects.syncFetchedRadiusFromSnapshot
          ? outcome.snapshotRadius
          : null,
      shouldResetPlannerOnPointsChanged: effects.resetPlannerOnPointsChanged,
      shouldStopCalculating:
          effects.reactionAction == RoomSyncAction.stopCalculating,
      shouldCalculateAsCreator:
          effects.reactionAction == RoomSyncAction.calculateAsCreator,
      shouldCalculateWithPartnerFallback: shouldCalculateWithPartnerFallback,
      fallbackPoint1: outcome.point1,
      fallbackPoint2: outcome.point2,
    );
  }
}
