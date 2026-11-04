import 'package:date_navigation/core/search/search_region.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to global for empty storage', () {
    expect(SearchRegion.fromStorage(null), SearchRegion.global);
    expect(SearchRegion.fromStorage(''), SearchRegion.global);
  });

  test('round-trips a custom region', () {
    const region = SearchRegion(
      id: 'custom',
      label: 'Warsaw',
      countryCode: 'pl',
      city: 'Warsaw',
      latitude: 52.2297,
      longitude: 21.0122,
      radiusKm: 30,
    );

    final restored = SearchRegion.fromJson(region.toJson());

    expect(restored.id, 'custom');
    expect(restored.label, 'Warsaw');
    expect(restored.countryCode, 'pl');
    expect(restored.latitude, 52.2297);
    expect(restored.longitude, 21.0122);
    expect(restored.radiusKm, 30);
  });

  test('cache key separates global and Minsk', () {
    expect(SearchRegion.global.cacheKey, isNot(SearchRegion.minsk.cacheKey));
    expect(SearchRegion.minsk.cacheKey, contains('by'));
  });
}
