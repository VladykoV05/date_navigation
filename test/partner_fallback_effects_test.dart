import 'package:date_navigation/features/date_navigation/domain/entities/date_vibe.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/meeting_point.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/place.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/route_info.dart';
import 'package:date_navigation/features/date_navigation/presentation/runtime/meeting_planner_runtime.dart';
import 'package:date_navigation/features/date_navigation/presentation/flows/partner_fallback_flow.dart';
import 'package:date_navigation/features/date_navigation/presentation/flows/partner_fallback_effects.dart';
import 'package:date_navigation/features/date_navigation/presentation/flows/partner_fallback_result_resolver.dart';
import 'package:date_navigation/features/date_navigation/presentation/state/date_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as latlong;

void main() {
  const coordinator = PartnerFallbackEffects();
  final resultResolver = PartnerFallbackResultResolver(
    const PartnerFallbackFlow(),
  );

  MeetingPoint meeting({required String placeName}) {
    return MeetingPoint(
      location: const latlong.LatLng(53.9, 27.56),
      userRoute: const RouteInfo(
        duration: Duration(minutes: 10),
        distance: 1200,
      ),
      partnerRoute: const RouteInfo(
        duration: Duration(minutes: 12),
        distance: 1300,
      ),
      nearbyPlaces: [Place(name: placeName, lat: 53.9, lon: 27.56)],
      fullRouteGeometry: const [latlong.LatLng(53.9, 27.56)],
    );
  }

  test('buildSuccess marks fetched radius when success clears failure', () {
    final planner = MeetingPlannerRuntime();
    const state = DateNavigationState(
      room: RoomSessionState(
        point1: latlong.LatLng(53.9, 27.56),
        point2: latlong.LatLng(53.91, 27.57),
      ),
      meeting: MeetingPlanningState(
        searchRadius: 640,
        selectedMeetingFormat: MeetingFormat.food,
      ),
    );

    final result = coordinator.buildSuccess(
      state: state,
      meeting: meeting(placeName: 'Place A'),
      point1: const latlong.LatLng(53.9, 27.56),
      point2: const latlong.LatLng(53.91, 27.57),
      meetingPlanner: planner,
      resultResolver: resultResolver,
    );

    expect(result.shouldMarkFetchedRadius, isTrue);
    expect(result.fetchedRadius, 640);
    expect(result.success.nextState.meeting.centerPoint, isNotNull);
    expect(result.success.nextState.meeting.foundPlaces, isNotEmpty);
  });

  test('buildSuccess skips mark when venue is already locked', () {
    final planner = MeetingPlannerRuntime();
    const state = DateNavigationState(
      room: RoomSessionState(
        point1: latlong.LatLng(53.9, 27.56),
        point2: latlong.LatLng(53.91, 27.57),
      ),
      meeting: MeetingPlanningState(
        searchRadius: 640,
        selectedMeetingFormat: MeetingFormat.food,
        finalChoiceName: 'Locked venue',
      ),
    );

    final result = coordinator.buildSuccess(
      state: state,
      meeting: meeting(placeName: 'Place B'),
      point1: const latlong.LatLng(53.9, 27.56),
      point2: const latlong.LatLng(53.91, 27.57),
      meetingPlanner: planner,
      resultResolver: resultResolver,
    );

    expect(result.shouldMarkFetchedRadius, isFalse);
    expect(result.fetchedRadius, isNull);
    expect(result.success.shouldClearFailure, isFalse);
    expect(result.success.shouldSaveSnapshot, isFalse);
  });
}
