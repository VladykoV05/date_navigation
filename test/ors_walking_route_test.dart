import 'dart:convert';

import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/ors_walking_route_data_source.dart';
import 'package:date_navigation/features/date_navigation/domain/ports/walking_route_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _from = (lat: 53.9, lon: 27.5667);
const _to = (lat: 53.91, lon: 27.55);

void main() {
  test('parses GeoJSON coordinates (lon, lat) into route points', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'test-key');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['coordinates'], [
        [_from.lon, _from.lat],
        [_to.lon, _to.lat],
      ]);
      return http.Response(
        jsonEncode({
          'features': [
            {
              'geometry': {
                'coordinates': [
                  [27.5667, 53.9],
                  [27.56, 53.905],
                  [27.55, 53.91],
                ],
              },
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final source = OrsWalkingRouteDataSource(
      client: client,
      apiKey: 'test-key',
    );

    final result = await source.route(from: _from, to: _to);

    expect(result, isA<Ok<List<RoutePoint>>>());
    final points = (result as Ok<List<RoutePoint>>).value;
    expect(points.length, 3);
    expect(points.first.lat, 53.9);
    expect(points.first.lon, 27.5667);
    expect(points.last.lat, 53.91);
  });

  test(
    'without a key nothing is requested and the result is an error',
    () async {
      var called = false;
      final client = MockClient((request) async {
        called = true;
        return http.Response('{}', 200);
      });
      final source = OrsWalkingRouteDataSource(client: client, apiKey: '');

      final result = await source.route(from: _from, to: _to);

      expect(result, isA<Err<List<RoutePoint>>>());
      expect(called, isFalse);
    },
  );

  test('server error becomes an error result', () async {
    final client = MockClient((request) async => http.Response('nope', 403));
    final source = OrsWalkingRouteDataSource(client: client, apiKey: 'bad');

    final result = await source.route(from: _from, to: _to);

    expect(result, isA<Err<List<RoutePoint>>>());
  });
}
