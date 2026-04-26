import 'package:latlong2/latlong.dart';

import 'place.dart';
import 'route_info.dart';

class MeetingPoint {
  final LatLng location;
  final RouteInfo userRoute;
  final RouteInfo partnerRoute;
  final List<Place> nearbyPlaces;
  final List<LatLng> fullRouteGeometry;

  MeetingPoint({
    required this.location,
    required this.userRoute,
    required this.partnerRoute,
    required this.nearbyPlaces,
    this.fullRouteGeometry = const [],
  });

  bool get isFair =>
      (userRoute.duration.inMinutes - partnerRoute.duration.inMinutes).abs() <=
      10;
}
