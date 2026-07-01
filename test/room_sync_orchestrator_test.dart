import 'package:date_navigation/features/date_navigation/application/sync/room_sync_orchestrator.dart';
import 'package:date_navigation/features/date_navigation/application/sync/room_sync_reaction_policy.dart';
import 'package:date_navigation/features/date_navigation/application/sync/room_snapshot_reducer.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/application/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_coordinate.dart';

void main() {
  const orchestrator = RoomSyncOrchestrator(RoomSyncReactionPolicy());

  RoomSyncOutcome outcome({
    required DateNavigationState nextState,
    required bool isCreator,
  }) {
    return RoomSyncOutcome(
      nextState: nextState,
      pointsChanged: true,
      isCreator: isCreator,
      venueLocked: false,
      hasSnapshot: false,
      snapshotUpdatedAt: null,
      point1: const GeoCoordinate(latitude: 53.9, longitude: 27.56),
      point2: const GeoCoordinate(latitude: 53.91, longitude: 27.57),
      snapshotRadius: null,
      snapshotMatchesFormat: false,
    );
  }

  test(
    'buildPlan suppresses reaction action when startMeetingSearch is true',
    () {
      final previous = const DateNavigationState();
      final nextState = const DateNavigationState(
        room: RoomSessionState(
          point1: GeoCoordinate(latitude: 53.9, longitude: 27.56),
          point2: GeoCoordinate(latitude: 53.91, longitude: 27.57),
        ),
        meeting: MeetingPlanningState(
          selectedMeetingFormat: MeetingFormat.food,
        ),
      );

      final plan = orchestrator.buildPlan(
        previousState: previous,
        outcome: outcome(nextState: nextState, isCreator: false),
        snapshotFreshFor: const Duration(seconds: 20),
        now: DateTime(2026, 1, 1, 12),
      );

      // Guard test: if search is not started the assertion below is not meaningful.
      if (!plan.startMeetingSearch) {
        // Make sure this test fails loudly if setup becomes invalid.
        fail('Test setup invalid: startMeetingSearch must be true.');
      }

      expect(plan.reactionAction, RoomSyncAction.none);
    },
  );
}
