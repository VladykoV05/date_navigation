import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/ports/walking_route_source.dart';

/// Пеший маршрут через OpenRouteService (профиль foot-walking).
/// Ключ передаётся из сборки; без ключа возвращается ошибка и приложение рисует прямую линию.
class OrsWalkingRouteDataSource implements WalkingRouteSource {
  OrsWalkingRouteDataSource({
    required http.Client client,
    required this.apiKey,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client;

  final http.Client _client;
  final String apiKey;
  final Duration timeout;

  static final Uri _endpoint = Uri.parse(
    'https://api.openrouteservice.org/v2/directions/foot-walking/geojson',
  );

  @override
  Future<Result<List<RoutePoint>>> route({
    required RoutePoint from,
    required RoutePoint to,
  }) async {
    if (apiKey.isEmpty) {
      return const Err(UnknownFailure(FailureCodes.walkingRouteFailed));
    }
    try {
      final response = await _client
          .post(
            _endpoint,
            headers: {
              'Authorization': apiKey,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'coordinates': [
                [from.lon, from.lat],
                [to.lon, to.lat],
              ],
            }),
          )
          .timeout(timeout);
      if (response.statusCode != 200) {
        return const Err(UnknownFailure(FailureCodes.walkingRouteFailed));
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final features = decoded is Map ? decoded['features'] : null;
      if (features is! List || features.isEmpty) {
        return const Err(UnknownFailure(FailureCodes.walkingRouteFailed));
      }
      final geometry = (features.first as Map)['geometry'] as Map?;
      final coords = geometry?['coordinates'];
      if (coords is! List) {
        return const Err(UnknownFailure(FailureCodes.walkingRouteFailed));
      }
      final points = <RoutePoint>[];
      for (final item in coords) {
        if (item is List &&
            item.length >= 2 &&
            item[0] is num &&
            item[1] is num) {
          points.add((
            lat: (item[1] as num).toDouble(),
            lon: (item[0] as num).toDouble(),
          ));
        }
      }
      if (points.length < 2) {
        return const Err(UnknownFailure(FailureCodes.walkingRouteFailed));
      }
      return Ok(points);
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.walkingRouteFailed));
    }
  }
}
