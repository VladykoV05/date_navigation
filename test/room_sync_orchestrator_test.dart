import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_orchestrator.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_reaction_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_coordinator.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const orchestrator = RoomSyncOrchestrator(RoomSyncReactionCoordinator());

  RoomSyncOutcome _outcome({
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
        selectedMeetingFormat: MeetingFormat.food,
        point1: latlong.LatLng(53.9, 27.56),
        point2: latlong.LatLng(53.91, 27.57),
      );

      final plan = orchestrator.buildPlan(
        previousState: previous,
        outcome: _outcome(nextState: nextState, isCreator: false),
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
