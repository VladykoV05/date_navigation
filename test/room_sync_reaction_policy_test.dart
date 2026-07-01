import 'package:date_navigation/features/date_navigation/application/sync/room_snapshot_reducer.dart';
import 'package:date_navigation/features/date_navigation/application/sync/room_sync_reaction_policy.dart';
import 'package:date_navigation/features/date_navigation/application/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_coordinate.dart';

void main() {
  const coordinator = RoomSyncReactionPolicy();
  const snapshotFreshFor = Duration(seconds: 20);
  final now = DateTime(2026, 1, 1, 12, 0, 0);

  RoomSyncOutcome makeOutcome({
    required bool venueLocked,
    required bool pointsChanged,
    required bool isCreator,
    required bool hasSnapshot,
    bool snapshotMatchesFormat = true,
    DateTime? snapshotUpdatedAt,
    GeoCoordinate? point1,
    GeoCoordinate? point2,
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
        point1: GeoCoordinate(latitude: 1, longitude: 1),
        point2: GeoCoordinate(latitude: 2, longitude: 2),
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
        point1: GeoCoordinate(latitude: 1, longitude: 1),
        point2: GeoCoordinate(latitude: 2, longitude: 2),
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
        point1: GeoCoordinate(latitude: 1, longitude: 1),
        point2: GeoCoordinate(latitude: 2, longitude: 2),
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
        point1: GeoCoordinate(latitude: 1, longitude: 1),
        point2: GeoCoordinate(latitude: 2, longitude: 2),
      ),
      snapshotFreshFor: snapshotFreshFor,
      now: now,
    );

    expect(action, RoomSyncAction.calculateWithPartnerFallback);
  });
}
