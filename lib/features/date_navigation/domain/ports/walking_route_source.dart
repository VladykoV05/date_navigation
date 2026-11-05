import '../../../../core/error/result.dart';

/// Точка маршрута (широта, долгота).
typedef RoutePoint = ({double lat, double lon});

/// Пеший маршрут по улицам. Реализация — внешний сервис (см. design 11.4).
abstract interface class WalkingRouteSource {
  Future<Result<List<RoutePoint>>> route({
    required RoutePoint from,
    required RoutePoint to,
  });
}
