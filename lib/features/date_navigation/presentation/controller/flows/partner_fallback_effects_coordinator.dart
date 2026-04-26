import 'package:latlong2/latlong.dart' as latlong;

import '../../../domain/entities/meeting_point.dart';
import '../../state/date_navigation_state.dart';
import '../meeting_planner_coordinator.dart';
import 'partner_fallback_result_coordinator.dart';

class PartnerFallbackEffectsResult {
  const PartnerFallbackEffectsResult({
    required this.success,
    required this.shouldMarkFetchedRadius,
    required this.fetchedRadius,
  });

  final PartnerFallbackSuccessResult success;
  final bool shouldMarkFetchedRadius;
  final int? fetchedRadius;
}

class PartnerFallbackEffectsCoordinator {
  const PartnerFallbackEffectsCoordinator();

  PartnerFallbackEffectsResult buildSuccess({
    required DateNavigationState state,
    required MeetingPoint meeting,
    required latlong.LatLng point1,
    required latlong.LatLng point2,
    required MeetingPlannerCoordinator meetingPlanner,
    required PartnerFallbackResultCoordinator resultCoordinator,
  }) {
    final filtered = meetingPlanner.computeFilteredPlaces(
      places: meeting.nearbyPlaces,
      point1: point1,
      point2: point2,
      selectedType: state.meeting.selectedType,
      centerPoint: meeting.location,
      searchRadius: state.meeting.searchRadius,
      meetingFormat: state.selectedMeetingFormat,
    );
    final success = resultCoordinator.resolveSuccess(
      state: state,
      meeting: meeting,
      filteredPlaces: filtered,
    );
    final fetchedRadius = success.shouldClearFailure
        ? state.meeting.searchRadius.round()
        : null;
    return PartnerFallbackEffectsResult(
      success: success,
      shouldMarkFetchedRadius: success.shouldClearFailure,
      fetchedRadius: fetchedRadius,
    );
  }
}
