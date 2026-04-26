class RouteInfo {
  final Duration duration;
  final double distance;

  const RouteInfo({required this.duration, required this.distance});

  factory RouteInfo.fromSeconds(double seconds, double meters) {
    return RouteInfo(
      duration: Duration(seconds: seconds.round()),
      distance: meters,
    );
  }
}
