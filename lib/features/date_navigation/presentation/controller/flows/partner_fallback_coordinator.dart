import '../../../domain/entities/meeting_point.dart';
import '../../../domain/entities/place.dart';
import '../../state/date_navigation_state.dart';

class PartnerFallbackCoordinator {
  const PartnerFallbackCoordinator();

  bool canRun({
    required DateNavigationState state,
    required bool isPartnerFallbackInFlight,
  }) {
    if (state.roomSession.isClosed) return false;
    if (state.selectedMeetingFormat == null) return false;
    if (isPartnerFallbackInFlight || state.roomSession.isCreator) return false;
    final finalChoice = state.meeting.finalChoiceName;
    if (finalChoice != null && finalChoice.isNotEmpty) return false;
    return true;
  }

  bool hasVenueLock(DateNavigationState state) {
    final finalChoice = state.meeting.finalChoiceName;
    return finalChoice != null && finalChoice.isNotEmpty;
  }

  DateNavigationState applyMeeting({
    required DateNavigationState state,
    required MeetingPoint meeting,
    required List<Place> filteredPlaces,
  }) {
    return state.copyWith(
      isCalculatingMeeting: false,
      centerPoint: meeting.location,
      foundPlaces: meeting.nearbyPlaces,
      filteredPlaces: filteredPlaces,
      routePoints: meeting.fullRouteGeometry,
    );
  }
}
