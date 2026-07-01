import '../../domain/entities/meeting_point.dart';
import '../../domain/value_objects/geo_coordinate.dart';
import '../state/date_navigation_state.dart';
import '../runtime/meeting_planner_runtime.dart';
import './partner_fallback_result_resolver.dart';

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

class PartnerFallbackEffects {
  const PartnerFallbackEffects();

  PartnerFallbackEffectsResult buildSuccess({
    required DateNavigationState state,
    required MeetingPoint meeting,
    required GeoCoordinate point1,
    required GeoCoordinate point2,
    required MeetingPlannerRuntime meetingPlanner,
    required PartnerFallbackResultResolver resultResolver,
  }) {
    final filtered = meetingPlanner.computeFilteredPlaces(
      places: meeting.nearbyPlaces,
      point1: point1,
      point2: point2,
      selectedType: state.meeting.selectedType,
      centerPoint: meeting.location,
      searchRadius: state.meeting.searchRadius,
      meetingFormat: state.meeting.selectedMeetingFormat,
    );
    final success = resultResolver.resolveSuccess(
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
