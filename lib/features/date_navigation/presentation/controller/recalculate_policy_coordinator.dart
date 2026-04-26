import '../state/date_navigation_state.dart';

class RecalculatePolicyCoordinator {
  const RecalculatePolicyCoordinator();

  bool canRecalculate(DateNavigationState state) {
    return state.point1 != null && state.point2 != null && !state.isLoading;
  }

  bool shouldStopAfterLocalFilter({
    required DateNavigationState state,
    required bool hasCenterAndPlaces,
    required bool shouldSkipRadiusFetch,
  }) {
    if (!hasCenterAndPlaces) return false;
    if (!state.isCreator) return true;
    if (shouldSkipRadiusFetch) return true;
    return false;
  }
}
