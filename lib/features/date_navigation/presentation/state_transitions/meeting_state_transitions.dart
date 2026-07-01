import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../state/date_navigation_state.dart';

class MeetingStateTransitions {
  const MeetingStateTransitions();

  bool isVenueLocked(DateNavigationState state) {
    final finalChoice = state.meeting.finalChoiceName;
    return finalChoice != null && finalChoice.isNotEmpty;
  }

  DateNavigationState applyMeetingSuccess({
    required DateNavigationState state,
    required MeetingPoint meeting,
    required List<Place> filteredPlaces,
  }) {
    return state.copyWith(
      meeting: state.meeting.copyWith(
        centerPoint: meeting.location,
        foundPlaces: meeting.nearbyPlaces,
        filteredPlaces: filteredPlaces,
        routePoints: meeting.fullRouteGeometry,
      ),
      ui: state.ui.copyWith(isCalculatingMeeting: false),
    );
  }

  DateNavigationState? applyScenarioSync({
    required DateNavigationState state,
    required List<DateScenario> scenarios,
  }) {
    if (scenarios.isEmpty) return null;
    final nextScenario = scenarios.first;
    if (state.meeting.selectedScenario?.id == nextScenario.id) return null;
    return state.copyWith(
      meeting: state.meeting.copyWith(
        dateScenarios: scenarios,
        selectedScenario: nextScenario,
      ),
    );
  }
}
