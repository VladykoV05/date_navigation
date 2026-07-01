import 'package:date_navigation/features/date_navigation/presentation/flows/room_stream_application.dart';
import 'package:date_navigation/features/date_navigation/presentation/flows/room_stream_effects.dart';
import 'package:date_navigation/features/date_navigation/presentation/reducers/room_stream_reducer.dart';
import 'package:date_navigation/features/date_navigation/presentation/sync/room_snapshot_reducer.dart';
import 'package:date_navigation/features/date_navigation/presentation/sync/room_sync_orchestrator.dart';
import 'package:date_navigation/features/date_navigation/presentation/sync/room_sync_reaction_policy.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const coordinator = RoomStreamApplication(RoomStreamEffects());

  RoomStreamUpdate update({
    required RoomSyncAction reactionAction,
    required latlong.LatLng? point1,
    required latlong.LatLng? point2,
    String? matchedFormat,
    int? snapshotRadius,
  }) {
    const nextState = DateNavigationState();
    final plan = RoomSyncPlan(
      nextState: nextState,
      trackMatchedFormat: matchedFormat != null,
      matchedFormatWireValue: matchedFormat,
      startMeetingSearch: false,
      syncScenarioForFinalChoice: false,
      syncFetchedRadiusFromSnapshot: snapshotRadius != null,
      resetPlannerOnPointsChanged: true,
      reactionAction: reactionAction,
    );
    final outcome = RoomSyncOutcome(
      nextState: nextState,
      pointsChanged: true,
      isCreator: false,
      venueLocked: false,
      hasSnapshot: snapshotRadius != null,
      snapshotUpdatedAt: null,
      point1: point1,
      point2: point2,
      snapshotRadius: snapshotRadius,
      snapshotMatchesFormat: true,
    );
    return RoomStreamUpdate(
      outcome: outcome,
      plan: plan,
      shouldRecoverMissingMeeting: false,
    );
  }

  test('build maps fallback action only when both points exist', () {
    final withPoints = coordinator.build(
      update(
        reactionAction: RoomSyncAction.calculateWithPartnerFallback,
        point1: const latlong.LatLng(1, 1),
        point2: const latlong.LatLng(2, 2),
      ),
    );
    final withoutPoint2 = coordinator.build(
      update(
        reactionAction: RoomSyncAction.calculateWithPartnerFallback,
        point1: const latlong.LatLng(1, 1),
        point2: null,
      ),
    );

    expect(withPoints.shouldCalculateWithPartnerFallback, isTrue);
    expect(withPoints.fallbackPoint1, isNotNull);
    expect(withPoints.fallbackPoint2, isNotNull);
    expect(withoutPoint2.shouldCalculateWithPartnerFallback, isFalse);
  });

  test('build propagates track/snapshot/reset flags', () {
    final result = coordinator.build(
      update(
        reactionAction: RoomSyncAction.none,
        point1: const latlong.LatLng(1, 1),
        point2: const latlong.LatLng(2, 2),
        matchedFormat: 'food',
        snapshotRadius: 1200,
      ),
    );

    expect(result.matchedFormatToTrack, 'food');
    expect(result.snapshotRadiusToSync, 1200);
    expect(result.shouldResetPlannerOnPointsChanged, isTrue);
    expect(result.shouldStopCalculating, isFalse);
  });
}
