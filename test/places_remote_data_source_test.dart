import 'dart:convert';

import 'package:date_navigation/features/date_navigation/data/datasources/remote/place_quality_service.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/places_remote_data_source.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('Nominatim fallback: name is not full display_name', () async {
    final mock = MockClient((req) async {
      // Overpass fails -> go to fallback
      if (req.method == 'POST') {
        return http.Response('{"error":"timeout"}', 408);
      }

      final data = [
        {
          'lat': '53.9000',
          'lon': '27.5667',
          'display_name': 'Cafe X, Some street, Minsk, Belarus',
        },
      ];
      return http.Response(jsonEncode(data), 200);
    });

    final ds = PlacesRemoteDataSource(client: mock);
    final places = await ds.findPlacesNearby(
      lat: 53.9,
      lon: 27.5667,
      format: MeetingFormat.food,
      radius: 500,
      maxRetries: 0,
    );

    expect(places, isNotEmpty);
    expect(places.first.name, 'Cafe X');
    expect(places.first.address, contains('Some street'));
  });

  test('stableSortPlaces is deterministic', () {
    const quality = PlaceQualityService();
    final places = <Place>[
      Place(name: 'B', lat: 1.0, lon: 2.0, type: 'cafe'),
      Place(name: 'a', lat: 1.0, lon: 2.0, type: 'bar'),
      Place(name: 'A', lat: 0.0, lon: 2.0, type: 'bar'),
    ];

    quality.stableSortPlaces(places);

    expect(
      places.map((e) => '${e.type}:${e.name.toLowerCase()}:${e.lat}').toList(),
      ['bar:a:0.0', 'bar:a:1.0', 'cafe:b:1.0'],
    );
  });
}
