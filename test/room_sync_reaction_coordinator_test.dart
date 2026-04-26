import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/controller/room_sync_reaction_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const coordinator = RoomSyncReactionCoordinator();
  const snapshotFreshFor = Duration(seconds: 20);
  final now = DateTime(2026, 1, 1, 12, 0, 0);

  RoomSyncOutcome makeOutcome({
    required bool venueLocked,
    required bool pointsChanged,
    required bool isCreator,
    required bool hasSnapshot,
    bool snapshotMatchesFormat = true,
    DateTime? snapshotUpdatedAt,
    latlong.LatLng? point1,
    latlong.LatLng? point2,
  }) {
    return RoomSyncOutcome(
      nextState: const DateNavigationState(),
      pointsChanged: pointsChanged,
      isCreator: isCreator,
      venueLocked: venueLocked,
      hasSnapshot: hasSnapshot,
      snapshotUpdatedAt: snapshotUpdatedAt,
      point1: point1,
      point2: point2,
      snapshotRadius: null,
      snapshotMatchesFormat: snapshotMatchesFormat,
    );
  }

  test('returns stopCalculating when venue is locked', () {
    final action = coordinator.decide(
      outcome: makeOutcome(
        venueLocked: true,
        pointsChanged: true,
        isCreator: true,
        hasSnapshot: false,
        point1: latlong.LatLng(1, 1),
        point2: latlong.LatLng(2, 2),
      ),
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );

    expect(action, RoomSyncAction.stopCalculating);
  });

  test('returns calculateAsCreator when creator has updated points', () {
    final action = coordinator.decide(
      outcome: makeOutcome(
        venueLocked: false,
        pointsChanged: true,
        isCreator: true,
        hasSnapshot: false,
        point1: latlong.LatLng(1, 1),
        point2: latlong.LatLng(2, 2),
      ),
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );

    expect(action, RoomSyncAction.calculateAsCreator);
  });

  test('returns fallback when partner snapshot is stale', () {
    final action = coordinator.decide(
      outcome: makeOutcome(
        venueLocked: false,
        pointsChanged: true,
        isCreator: false,
        hasSnapshot: true,
        snapshotUpdatedAt: now.subtract(const Duration(seconds: 30)),
        point1: latlong.LatLng(1, 1),
        point2: latlong.LatLng(2, 2),
      ),
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );

    expect(action, RoomSyncAction.calculateWithPartnerFallback);
  });

  test('returns fallback when snapshot is fresh but from another format', () {
    final action = coordinator.decide(
      outcome: makeOutcome(
        venueLocked: false,
        pointsChanged: true,
        isCreator: false,
        hasSnapshot: true,
        snapshotMatchesFormat: false,
        snapshotUpdatedAt: now.subtract(const Duration(seconds: 5)),
        point1: latlong.LatLng(1, 1),
        point2: latlong.LatLng(2, 2),
      ),
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );

    expect(action, RoomSyncAction.calculateWithPartnerFallback);
  });
}
