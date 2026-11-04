import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/core/search/search_region.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/local/cache_service.dart';
import 'package:date_navigation/features/date_navigation/data/datasources/remote/geocoding_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('global region does not send countrycodes or viewbox', () async {
    Uri? captured;
    final client = MockClient((request) async {
      captured = request.url;
      return http.Response('[{"lat":"52.5200","lon":"13.4050"}]', 200);
    });
    final source = GeocodingRemoteDataSource(
      client: client,
      cache: CacheService(),
      acceptLanguage: () => 'en',
      cacheLocaleTag: () => 'en',
      searchRegion: () => SearchRegion.global,
    );

    final result = await source.geocodeAddress('Berlin');

    expect(result, isA<Ok<({double lat, double lon})?>>());
    expect(captured?.queryParameters.containsKey('countrycodes'), isFalse);
    expect(captured?.queryParameters.containsKey('viewbox'), isFalse);
  });

  test('Minsk region sends countrycodes=by and viewbox', () async {
    Uri? captured;
    final client = MockClient((request) async {
      captured = request.url;
      return http.Response('[{"lat":"53.9045","lon":"27.5615"}]', 200);
    });
    final source = GeocodingRemoteDataSource(
      client: client,
      cache: CacheService(),
      acceptLanguage: () => 'en',
      cacheLocaleTag: () => 'en',
      searchRegion: () => SearchRegion.minsk,
    );

    final result = await source.geocodeAddress('Nezavisimosti 10');

    expect(result, isA<Ok<({double lat, double lon})?>>());
    expect(captured?.queryParameters['countrycodes'], 'by');
    expect(captured?.queryParameters.containsKey('viewbox'), isTrue);
  });
}
