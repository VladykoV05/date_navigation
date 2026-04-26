import '../../../domain/entities/place.dart';
import '../../state/date_navigation_state.dart';
import '../date_assistant_coordinator.dart';
import '../meeting_state_coordinator.dart';

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

class FinalChoiceScenarioSyncCoordinator {
  const FinalChoiceScenarioSyncCoordinator();

  FinalChoiceScenarioSyncResult resolve({
    required DateNavigationState state,
    required DateAssistantCoordinator dateAssistant,
    required MeetingStateCoordinator meetingState,
  }) {
    final format = state.selectedMeetingFormat;
    final finalChoiceName = state.meeting.finalChoiceName;
    if (format == null || finalChoiceName == null || finalChoiceName.isEmpty) {
      return const FinalChoiceScenarioSyncResult.noop();
    }
    final place =
        state.meeting.finalChoicePlace ??
        Place(name: finalChoiceName, lat: 0, lon: 0);
    final scenarios = dateAssistant.buildScenarios(format: format, places: [place]);
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
      stepsCount: nextState.selectedScenario?.steps.length ?? 0,
    );
  }
}
