import '../state/date_navigation_state.dart';

class RecalculatePolicy {
  const RecalculatePolicy();

  bool canRecalculate(DateNavigationState state) {
    return state.room.point1 != null &&
        state.room.point2 != null &&
        !state.ui.isLoading;
  }

  bool shouldStopAfterLocalFilter({
    required DateNavigationState state,
    required bool hasCenterAndPlaces,
    required bool shouldSkipRadiusFetch,
  }) {
    if (!hasCenterAndPlaces) return false;
    if (!state.room.isCreator) return true;
    if (shouldSkipRadiusFetch) return true;
    return false;
  }
}
