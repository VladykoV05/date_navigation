import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_distance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('distance of about 1 km north is close to 1000 m', () {
    // 0.009 degrees of latitude is roughly 1 km.
    final d = distanceMeters(53.9, 27.5, 53.909, 27.5);
    expect(d, closeTo(1000, 15));
  });

  test('same point has zero distance', () {
    expect(distanceMeters(53.9, 27.5, 53.9, 27.5), 0);
  });
}
