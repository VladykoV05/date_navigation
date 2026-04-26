import 'package:date_navigation/features/date_navigation/data/datasources/remote/place_quality_service.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const quality = PlaceQualityService();

  test('isUsablePlace blocks educational/office noise by type', () {
    final blocked = Place(
      name: 'Some center',
      lat: 53.9,
      lon: 27.56,
      type: 'school',
      address: 'Минск, ул. Тестовая 1',
    );

    expect(quality.isUsablePlace(blocked), isFalse);
  });

  test('isUsablePlace blocks educational/office noise by name', () {
    final blockedByName = Place(
      name: 'Центр образовательных услуг',
      lat: 53.9,
      lon: 27.56,
      type: 'cafe',
      address: 'Минск, ул. Тестовая 2',
    );

    expect(quality.isUsablePlace(blockedByName), isFalse);
  });

  test('isUsablePlace blocks generic park polygons', () {
    final genericPark = Place(
      name: 'Парк',
      lat: 53.9,
      lon: 27.56,
      type: 'park',
      address: 'Минск',
    );
    final namedPark = Place(
      name: 'Парк Челюскинцев',
      lat: 53.9,
      lon: 27.56,
      type: 'park',
      address: 'Минск, проспект Независимости',
    );

    expect(quality.isUsablePlace(genericPark), isFalse);
    expect(quality.isUsablePlace(namedPark), isTrue);
  });

  test('swimming pool filter includes sports centre places', () {
    final place = Place(
      name: 'Спорткомплекс Юность',
      lat: 53.9,
      lon: 27.56,
      type: 'sports_centre',
      address: 'Минск, ул. Спортивная 1',
    );

    expect(place.matchesType('sports_centre'), isTrue);
    expect(place.matchesType('swimming_pool'), isTrue);
  });

  test('isUsablePlace requires address or rating for all places', () {
    final withoutMeta = Place(
      name: 'Coffee Spot',
      lat: 53.9,
      lon: 27.56,
      type: 'cafe',
    );
    final withAddress = Place(
      name: 'Coffee Spot',
      lat: 53.9,
      lon: 27.56,
      type: 'cafe',
      address: 'Минск, ул. Ленина 1',
    );
    final withRating = Place(
      name: 'Coffee Spot',
      lat: 53.9,
      lon: 27.56,
      type: 'cafe',
      rating: 4.3,
    );

    expect(quality.isUsablePlace(withoutMeta), isFalse);
    expect(quality.isUsablePlace(withAddress), isTrue);
    expect(quality.isUsablePlace(withRating), isTrue);
  });

  test(
    'dedupePlaces collapses nearby duplicates with same semantic identity',
    () {
      final places = <Place>[
        Place(
          name: 'Белорусский государственный цирк',
          lat: 53.912500,
          lon: 27.573600,
          address: 'проспект Незалежнасці 32, Мінск',
          type: 'theatre',
        ),
        Place(
          name: 'Белорусский государственный цирк',
          lat: 53.912620,
          lon: 27.573640,
          address: 'проспект Незалежнасці 32, Минск',
          type: 'theatre',
        ),
      ];

      final deduped = quality.dedupePlaces(places);

      expect(deduped.length, 1);
      expect(deduped.first.name, contains('цирк'));
    },
  );
}
