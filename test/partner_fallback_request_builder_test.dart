import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/application/flows/partner_fallback_request_builder.dart';
import 'package:date_navigation/features/date_navigation/application/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_coordinate.dart';

void main() {
  const coordinator = PartnerFallbackRequestBuilder();

  test('build returns null when selected format is missing', () {
    const state = DateNavigationState(
      meeting: MeetingPlanningState(searchRadius: 777),
    );
    final request = coordinator.build(
      state: state,
      point1: const GeoCoordinate(latitude: 53.9, longitude: 27.56),
      point2: const GeoCoordinate(latitude: 53.91, longitude: 27.57),
    );

    expect(request, isNull);
  });

  test('build returns payload with rounded radius and format', () {
    const state = DateNavigationState(
      meeting: MeetingPlanningState(
        searchRadius: 799.6,
        selectedMeetingFormat: MeetingFormat.food,
      ),
    );
    final point1 = const GeoCoordinate(latitude: 53.9, longitude: 27.56);
    final point2 = const GeoCoordinate(latitude: 53.91, longitude: 27.57);

    final request = coordinator.build(
      state: state,
      point1: point1,
      point2: point2,
    );

    expect(request, isNotNull);
    expect(request!.searchRadius, 800);
    expect(request.format, MeetingFormat.food);
    expect(request.point1, point1);
    expect(request.point2, point2);
  });
}
