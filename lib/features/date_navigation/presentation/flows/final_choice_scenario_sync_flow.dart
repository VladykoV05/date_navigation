import '../../domain/entities/place.dart';
import '../state/date_navigation_state.dart';
import '../services/date_assistant_service.dart';
import '../state_transitions/meeting_state_transitions.dart';

class FinalChoiceScenarioSyncResult {
  const FinalChoiceScenarioSyncResult({
    required this.nextState,
    required this.analyticsFormatWireValue,
    required this.stepsCount,
  });

  const FinalChoiceScenarioSyncResult.noop()
    : this(nextState: null, analyticsFormatWireValue: null, stepsCount: null);

  final DateNavigationState? nextState;
  final String? analyticsFormatWireValue;
  final int? stepsCount;

  bool get hasChanges => nextState != null;
}

class FinalChoiceScenarioSyncFlow {
  const FinalChoiceScenarioSyncFlow();

  FinalChoiceScenarioSyncResult resolve({
    required DateNavigationState state,
    required DateAssistantService dateAssistant,
    required MeetingStateTransitions meetingState,
  }) {
    final format = state.meeting.selectedMeetingFormat;
    final finalChoiceName = state.meeting.finalChoiceName;
    if (format == null || finalChoiceName == null || finalChoiceName.isEmpty) {
      return const FinalChoiceScenarioSyncResult.noop();
    }
    final place =
        state.meeting.finalChoicePlace ??
        Place(name: finalChoiceName, lat: 0, lon: 0);
    final scenarios = dateAssistant.buildScenarios(
      format: format,
      places: [place],
    );
    final nextState = meetingState.applyScenarioSync(
      state: state,
      scenarios: scenarios,
    );
    if (nextState == null) {
      return const FinalChoiceScenarioSyncResult.noop();
    }
    return FinalChoiceScenarioSyncResult(
      nextState: nextState,
      analyticsFormatWireValue: format.wireValue,
      stepsCount: nextState.meeting.selectedScenario?.steps.length ?? 0,
    );
  }
}
