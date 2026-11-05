import '../../../../core/error/result.dart';
import '../ports/walking_route_source.dart';

class FetchWalkingRoute {
  const FetchWalkingRoute(this._source);
  final WalkingRouteSource _source;

  Future<Result<List<RoutePoint>>> call({
    required RoutePoint from,
    required RoutePoint to,
  }) {
    return _source.route(from: from, to: to);
  }
}
