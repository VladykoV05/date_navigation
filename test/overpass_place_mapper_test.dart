import 'package:date_navigation/features/date_navigation/data/mappers/overpass_place_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = OverpassPlaceMapper();

  test('maps Overpass tags to a clean Place entity', () {
    final place = mapper.fromJson({
      'lat': 53.9,
      'lon': 27.56,
      'tags': {
        'amenity': 'restaurant',
        'name:ru': 'Тестовое место',
        'addr:street': 'Немига',
        'addr:housenumber': '1',
        'addr:city': 'Минск',
        'rating': '4.5',
      },
    });

    expect(place.name, 'Тестовое место');
    expect(place.address, 'Немига 1, Минск');
    expect(place.type, 'restaurant');
    expect(place.types, contains('restaurant'));
    expect(place.rating, 4.5);
  });
}
