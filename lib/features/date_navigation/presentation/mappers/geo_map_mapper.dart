import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/value_objects/geo_coordinate.dart';

class GeoMapMapper {
  const GeoMapMapper._();

  static latlong.LatLng toLatLng(GeoCoordinate value) {
    return latlong.LatLng(value.latitude, value.longitude);
  }

  static latlong.LatLng? toLatLngOrNull(GeoCoordinate? value) {
    if (value == null) return null;
    return toLatLng(value);
  }

  static List<latlong.LatLng> toLatLngList(List<GeoCoordinate> values) {
    return values.map(toLatLng).toList(growable: false);
  }
}
