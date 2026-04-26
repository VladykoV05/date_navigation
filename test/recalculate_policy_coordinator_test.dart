import 'package:date_navigation/features/date_navigation/presentation/controller/recalculate_policy_coordinator.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const coordinator = RecalculatePolicyCoordinator();

  test('canRecalculate returns false when one point is missing', () {
    final state = DateNavigationState(
      point1: latlong.LatLng(1, 1),
    );

    expect(coordinator.canRecalculate(state), isFalse);
  });

  test('canRecalculate returns false when loading', () {
    final state = DateNavigationState(
      point1: latlong.LatLng(1, 1),
      point2: latlong.LatLng(2, 2),
      isCalculatingMeeting: true,
    );

    expect(coordinator.canRecalculate(state), isFalse);
  });

  test('shouldStopAfterLocalFilter returns true for non-creator', () {
    const state = DateNavigationState(isCreator: false);

    expect(
      coordinator.shouldStopAfterLocalFilter(
        state: state,
        hasCenterAndPlaces: true,
        shouldSkipRadiusFetch: false,
      ),
      isTrue,
    );
  });
}
