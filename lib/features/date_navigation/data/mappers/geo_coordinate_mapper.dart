import 'package:latlong2/latlong.dart' as latlong;

import '../../domain/value_objects/geo_coordinate.dart';

class GeoCoordinateMapper {
  const GeoCoordinateMapper._();

  static GeoCoordinate fromLatLng(latlong.LatLng value) {
    return GeoCoordinate(
      latitude: value.latitude,
      longitude: value.longitude,
    );
  }

  static latlong.LatLng toLatLng(GeoCoordinate value) {
    return latlong.LatLng(value.latitude, value.longitude);
  }

  static GeoCoordinate? fromLatLngOrNull(latlong.LatLng? value) {
    if (value == null) return null;
    return fromLatLng(value);
  }

  static latlong.LatLng? toLatLngOrNull(GeoCoordinate? value) {
    if (value == null) return null;
    return toLatLng(value);
  }

  static List<GeoCoordinate> fromLatLngList(List<latlong.LatLng> values) {
    return values.map(fromLatLng).toList(growable: false);
  }

  static List<latlong.LatLng> toLatLngList(List<GeoCoordinate> values) {
    return values.map(toLatLng).toList(growable: false);
  }

  static GeoCoordinate? fromWireMap(dynamic raw) {
    if (raw == null) return null;
    if (raw is! Map) return null;
    return GeoCoordinate(
      latitude: (raw['lat'] as num?)?.toDouble() ?? 0,
      longitude: (raw['lng'] as num?)?.toDouble() ?? 0,
    );
  }

  static List<GeoCoordinate> routePointsFromWireList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (point) => GeoCoordinate(
            latitude: (point['lat'] as num?)?.toDouble() ?? 0,
            longitude: (point['lng'] as num?)?.toDouble() ?? 0,
          ),
        )
        .where((point) => point.latitude != 0 || point.longitude != 0)
        .toList(growable: false);
  }
}
