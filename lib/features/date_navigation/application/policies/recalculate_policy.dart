class RecalculatePolicy {
  const RecalculatePolicy();

  bool canRecalculate({
    required bool hasPoint1,
    required bool hasPoint2,
    required bool isLoading,
  }) {
    return hasPoint1 && hasPoint2 && !isLoading;
  }

  bool shouldStopAfterLocalFilter({
    required bool isCreator,
    required bool hasCenterAndPlaces,
    required bool shouldSkipRadiusFetch,
  }) {
    if (!hasCenterAndPlaces) return false;
    if (!isCreator) return true;
    if (shouldSkipRadiusFetch) return true;
    return false;
  }
}
