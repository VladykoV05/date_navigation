import 'package:date_navigation/features/date_navigation/application/policies/recalculate_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = RecalculatePolicy();

  test('canRecalculate returns false when one point is missing', () {
    expect(
      policy.canRecalculate(
        hasPoint1: true,
        hasPoint2: false,
        isLoading: false,
      ),
      isFalse,
    );
  });

  test('canRecalculate returns false when loading', () {
    expect(
      policy.canRecalculate(
        hasPoint1: true,
        hasPoint2: true,
        isLoading: true,
      ),
      isFalse,
    );
  });

  test('shouldStopAfterLocalFilter returns true for non-creator', () {
    expect(
      policy.shouldStopAfterLocalFilter(
        isCreator: false,
        hasCenterAndPlaces: true,
        shouldSkipRadiusFetch: false,
      ),
      isTrue,
    );
  });
}
