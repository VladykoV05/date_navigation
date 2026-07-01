import '../value_objects/geo_coordinate.dart';
import 'place.dart';
import 'route_info.dart';

class MeetingPoint {
  final GeoCoordinate location;
  final RouteInfo userRoute;
  final RouteInfo partnerRoute;
  final List<Place> nearbyPlaces;
  final List<GeoCoordinate> fullRouteGeometry;

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
