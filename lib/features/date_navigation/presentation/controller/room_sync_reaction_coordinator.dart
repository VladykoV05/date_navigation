import 'room_sync_coordinator.dart';

enum RoomSyncAction {
  none,
  stopCalculating,
  calculateAsCreator,
  calculateWithPartnerFallback,
}

class RoomSyncReactionCoordinator {
  const RoomSyncReactionCoordinator();

  RoomSyncAction decide({
    required RoomSyncOutcome outcome,
    required Duration snapshotFreshFor,
    required DateTime now,
  }) {
    if (outcome.venueLocked) {
      return RoomSyncAction.stopCalculating;
    }
    if (outcome.point1 == null || outcome.point2 == null || !outcome.pointsChanged) {
      return RoomSyncAction.none;
    }
    if (outcome.isCreator) {
      return RoomSyncAction.calculateAsCreator;
    }
    final snapshotFresh =
        outcome.hasSnapshot &&
        outcome.snapshotMatchesFormat &&
        outcome.snapshotUpdatedAt != null &&
        now.difference(outcome.snapshotUpdatedAt!) <= snapshotFreshFor;
    if (snapshotFresh) {
      return RoomSyncAction.stopCalculating;
    }
    return RoomSyncAction.calculateWithPartnerFallback;
  }
}
