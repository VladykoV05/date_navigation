import 'package:date_navigation/features/date_navigation/presentation/sync/room_sync_orchestrator.dart';
import 'package:date_navigation/features/date_navigation/presentation/sync/room_sync_reaction_policy.dart';
import 'package:date_navigation/features/date_navigation/presentation/sync/room_snapshot_reducer.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

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
      point1: const latlong.LatLng(53.9, 27.56),
      point2: const latlong.LatLng(53.91, 27.57),
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
          point1: latlong.LatLng(53.9, 27.56),
          point2: latlong.LatLng(53.91, 27.57),
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
