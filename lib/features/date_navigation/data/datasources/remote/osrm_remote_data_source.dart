import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../../core/utils/app_logger.dart';
import '../local/cache_service.dart';
import '../../../domain/entities/route_info.dart';

class OsrmRemoteDataSource {
  static const String baseUrl = 'https://router.project-osrm.org';

  final http.Client _client;
  final CacheService _cache;

  OsrmRemoteDataSource({required http.Client client, CacheService? cache})
    : _client = client,
      _cache = cache ?? CacheService();

  Future<({LatLng meetingPoint, List<LatLng> fullPolyline})> getMeetingData({
    required LatLng from,
    required LatLng to,
    double fraction = 0.5,
  }) async {
    AppLogger.d('🌐 OSRM: Запрос геометрии и точки встречи');

    final url =
        '$baseUrl/route/v1/driving/'
        '${from.longitude},${from.latitude};'
        '${to.longitude},${to.latitude}'
        '?overview=full&geometries=polyline&annotations=duration,distance';

    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception('Ошибка сервера OSRM: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data['routes'] == null || data['routes'].isEmpty) {
        throw Exception('Маршрут не найден');
      }

      final String encodedGeometry = data['routes'][0]['geometry'];
      final List<LatLng> points = _decodePolyline(encodedGeometry);
      if (points.isEmpty) throw Exception('Пустая геометрия');

      final annotations =
          data['routes'][0]['legs']?[0]?['annotation'] as Map<String, dynamic>?;
      final durations =
          (annotations?['duration'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList(growable: false) ??
          const <double>[];
      final meetingPoint = _findPointByHalfDuration(
        points: points,
        segmentDurationsSec: durations,
        fraction: fraction,
      );

      if (meetingPoint.latitude.abs() > 90 ||
          meetingPoint.longitude.abs() > 180) {
        AppLogger.w('⚠️ Некорректные координаты, применяем сдвиг 1e1');
        return (
          meetingPoint: _getGeometricCenter(from, to),
          fullPolyline: points
              .map((p) => LatLng(p.latitude / 10, p.longitude / 10))
              .toList(),
        );
      }

      return (meetingPoint: meetingPoint, fullPolyline: points);
    } catch (e) {
      AppLogger.e('💥 OSRM Exception: $e');
      return (
        meetingPoint: _getGeometricCenter(from, to),
        fullPolyline: <LatLng>[],
      );
    }
  }

  Future<RouteInfo> getRouteInfo({
    required LatLng from,
    required LatLng to,
  }) async {
    if (from.latitude == to.latitude && from.longitude == to.longitude) {
      return const RouteInfo(duration: Duration.zero, distance: 0);
    }

    final routeKey = _cache.makeRouteKey(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
    final cached = await _cache.getCachedRoute(routeKey);
    if (cached != null) {
      final cachedDuration = cached['duration'];
      final cachedDistance = cached['distance'];
      if (cachedDuration != null && cachedDistance != null) {
        return RouteInfo(
          duration: Duration(seconds: cachedDuration.round()),
          distance: cachedDistance,
        );
      }
      AppLogger.w('OSRM route cache has invalid payload, ignoring entry');
    }

    final url =
        '$baseUrl/route/v1/driving/'
        '${from.longitude},${from.latitude};'
        '${to.longitude},${to.latitude}?overview=false';

    try {
      final response = await _client.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['routes'] == null || data['routes'].isEmpty) {
        return const RouteInfo(duration: Duration.zero, distance: 0);
      }

      final route = data['routes'][0];
      final durationValue = route['duration'];
      final distanceValue = route['distance'];
      if (durationValue is! num || distanceValue is! num) {
        AppLogger.w('OSRM route payload missing numeric duration/distance');
        return const RouteInfo(duration: Duration.zero, distance: 0);
      }
      final duration = durationValue.toDouble();
      final distance = distanceValue.toDouble();

      await _cache.cacheRoute(routeKey, duration, distance);
      return RouteInfo(
        duration: Duration(seconds: duration.round()),
        distance: distance,
      );
    } catch (e) {
      return const RouteInfo(duration: Duration.zero, distance: 0);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  LatLng _getGeometricCenter(LatLng from, LatLng to) => LatLng(
    (from.latitude + to.latitude) / 2,
    (from.longitude + to.longitude) / 2,
  );

  LatLng _findPointByHalfDuration({
    required List<LatLng> points,
    required List<double> segmentDurationsSec,
    required double fraction,
  }) {
    if (points.length < 2) return points.first;
    if (segmentDurationsSec.length != points.length - 1) {
      final targetIndex = (points.length * fraction).round().clamp(
        0,
        points.length - 1,
      );
      return points[targetIndex];
    }

    final total = segmentDurationsSec.fold<double>(0.0, (a, b) => a + b);
    if (total <= 0) {
      final targetIndex = (points.length * fraction).round().clamp(
        0,
        points.length - 1,
      );
      return points[targetIndex];
    }

    final target = total * fraction.clamp(0.0, 1.0);
    var acc = 0.0;
    for (var i = 0; i < segmentDurationsSec.length; i++) {
      final seg = segmentDurationsSec[i];
      final nextAcc = acc + seg;
      if (target <= nextAcc) {
        final t = seg <= 0 ? 0.0 : ((target - acc) / seg).clamp(0.0, 1.0);
        final p1 = points[i];
        final p2 = points[i + 1];
        return LatLng(
          p1.latitude + (p2.latitude - p1.latitude) * t,
          p1.longitude + (p2.longitude - p1.longitude) * t,
        );
      }
      acc = nextAcc;
    }
    return points.last;
  }
}
