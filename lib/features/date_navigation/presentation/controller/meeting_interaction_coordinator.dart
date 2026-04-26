import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../state/date_navigation_state.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';

class MeetingInteractionCoordinator {
  const MeetingInteractionCoordinator();

  DateNavigationState onMeetingFormatsSubmitted(
    DateNavigationState state, {
    required Set<MeetingFormat> formats,
  }) {
    final normalized = _normalizeFormats(formats);
    final creatorMeetingFormats = state.isCreator
        ? normalized
        : state.creatorMeetingFormats;
    final partnerMeetingFormats = state.isCreator
        ? state.partnerMeetingFormats
        : normalized;
    final commonFormats = creatorMeetingFormats
        .where((format) => partnerMeetingFormats.contains(format))
        .toList(growable: false);
    final creatorSelectedMeetingFormat = state.isCreator
        ? (normalized.contains(state.creatorSelectedMeetingFormat)
              ? state.creatorSelectedMeetingFormat
              : null)
        : state.creatorSelectedMeetingFormat;
    final partnerSelectedMeetingFormat = state.isCreator
        ? state.partnerSelectedMeetingFormat
        : (normalized.contains(state.partnerSelectedMeetingFormat)
              ? state.partnerSelectedMeetingFormat
              : null);
    final selectedMeetingFormat =
        creatorSelectedMeetingFormat != null &&
            creatorSelectedMeetingFormat == partnerSelectedMeetingFormat &&
            commonFormats.contains(creatorSelectedMeetingFormat)
        ? creatorSelectedMeetingFormat
        : null;
    final lastAgreedMeetingFormat =
        selectedMeetingFormat ?? state.lastAgreedMeetingFormat;
    final shouldClearPlaces = selectedMeetingFormat != state.selectedMeetingFormat;
    return state.copyWith(
      creatorMeetingFormats: creatorMeetingFormats,
      partnerMeetingFormats: partnerMeetingFormats,
      creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
      partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
      selectedMeetingFormat: selectedMeetingFormat,
      lastAgreedMeetingFormat: lastAgreedMeetingFormat,
      dateScenarios: const [],
      selectedScenario: null,
      foundPlaces: shouldClearPlaces ? const [] : state.foundPlaces,
      filteredPlaces: shouldClearPlaces ? const [] : state.filteredPlaces,
      centerPoint: shouldClearPlaces ? null : state.centerPoint,
      routePoints: shouldClearPlaces ? const [] : state.routePoints,
    );
  }

  DateNavigationState onMeetingFormatConfirmed(
    DateNavigationState state, {
    required MeetingFormat format,
  }) {
    if (!state.commonMeetingFormats.contains(format)) {
      return state;
    }
    final creatorSelectedMeetingFormat = state.isCreator
        ? format
        : state.creatorSelectedMeetingFormat;
    final partnerSelectedMeetingFormat = state.isCreator
        ? state.partnerSelectedMeetingFormat
        : format;
    final nextSelectedMeetingFormat =
        creatorSelectedMeetingFormat != null &&
            creatorSelectedMeetingFormat == partnerSelectedMeetingFormat
        ? creatorSelectedMeetingFormat
        : null;
    final lastAgreedMeetingFormat =
        nextSelectedMeetingFormat ?? state.lastAgreedMeetingFormat;
    final shouldClearPlaces = nextSelectedMeetingFormat != state.selectedMeetingFormat;
    return state.copyWith(
      creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
      partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
      selectedMeetingFormat: nextSelectedMeetingFormat,
      lastAgreedMeetingFormat: lastAgreedMeetingFormat,
      dateScenarios: const [],
      selectedScenario: null,
      foundPlaces: shouldClearPlaces ? const [] : state.foundPlaces,
      filteredPlaces: shouldClearPlaces ? const [] : state.filteredPlaces,
      centerPoint: shouldClearPlaces ? null : state.centerPoint,
      routePoints: shouldClearPlaces ? const [] : state.routePoints,
    );
  }

  DateNavigationState onScenarioSelected(
    DateNavigationState state, {
    required DateScenario scenario,
  }) {
    return state.copyWith(
      selectedScenario: scenario,
      errorMessage: null,
      failureOperation: null,
    );
  }

  Failure? mapInteractionFailure(Result<void> result) {
    if (result case Err(:final failure)) return failure;
    return null;
  }

  List<MeetingFormat> _normalizeFormats(Set<MeetingFormat> formats) {
    final list = formats.toList(growable: false);
    list.sort((a, b) => a.index.compareTo(b.index));
    return list;
  }
}
