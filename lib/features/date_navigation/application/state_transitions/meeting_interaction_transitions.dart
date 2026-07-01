import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../state/date_navigation_state.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';

class MeetingInteractionTransitions {
  const MeetingInteractionTransitions();

  DateNavigationState onMeetingFormatsSubmitted(
    DateNavigationState state, {
    required Set<MeetingFormat> formats,
  }) {
    final normalized = _normalizeFormats(formats);
    final creatorMeetingFormats = state.room.isCreator
        ? normalized
        : state.meeting.creatorMeetingFormats;
    final partnerMeetingFormats = state.room.isCreator
        ? state.meeting.partnerMeetingFormats
        : normalized;
    final commonFormats = creatorMeetingFormats
        .where((format) => partnerMeetingFormats.contains(format))
        .toList(growable: false);
    final creatorSelectedMeetingFormat = state.room.isCreator
        ? (normalized.contains(state.meeting.creatorSelectedMeetingFormat)
              ? state.meeting.creatorSelectedMeetingFormat
              : null)
        : state.meeting.creatorSelectedMeetingFormat;
    final partnerSelectedMeetingFormat = state.room.isCreator
        ? state.meeting.partnerSelectedMeetingFormat
        : (normalized.contains(state.meeting.partnerSelectedMeetingFormat)
              ? state.meeting.partnerSelectedMeetingFormat
              : null);
    final selectedMeetingFormat =
        creatorSelectedMeetingFormat != null &&
            creatorSelectedMeetingFormat == partnerSelectedMeetingFormat &&
            commonFormats.contains(creatorSelectedMeetingFormat)
        ? creatorSelectedMeetingFormat
        : null;
    final lastAgreedMeetingFormat =
        selectedMeetingFormat ?? state.meeting.lastAgreedMeetingFormat;
    final shouldClearPlaces =
        selectedMeetingFormat != state.meeting.selectedMeetingFormat;
    return state.copyWith(
      meeting: state.meeting.copyWith(
        creatorMeetingFormats: creatorMeetingFormats,
        partnerMeetingFormats: partnerMeetingFormats,
        creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
        partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
        selectedMeetingFormat: selectedMeetingFormat,
        lastAgreedMeetingFormat: lastAgreedMeetingFormat,
        dateScenarios: const [],
        selectedScenario: null,
        foundPlaces: shouldClearPlaces ? const [] : state.meeting.foundPlaces,
        filteredPlaces: shouldClearPlaces
            ? const []
            : state.meeting.filteredPlaces,
        centerPoint: shouldClearPlaces ? null : state.meeting.centerPoint,
        routePoints: shouldClearPlaces ? const [] : state.meeting.routePoints,
      ),
    );
  }

  DateNavigationState onMeetingFormatConfirmed(
    DateNavigationState state, {
    required MeetingFormat format,
  }) {
    if (!state.meeting.commonMeetingFormats.contains(format)) {
      return state;
    }
    final creatorSelectedMeetingFormat = state.room.isCreator
        ? format
        : state.meeting.creatorSelectedMeetingFormat;
    final partnerSelectedMeetingFormat = state.room.isCreator
        ? state.meeting.partnerSelectedMeetingFormat
        : format;
    final nextSelectedMeetingFormat =
        creatorSelectedMeetingFormat != null &&
            creatorSelectedMeetingFormat == partnerSelectedMeetingFormat
        ? creatorSelectedMeetingFormat
        : null;
    final lastAgreedMeetingFormat =
        nextSelectedMeetingFormat ?? state.meeting.lastAgreedMeetingFormat;
    final shouldClearPlaces =
        nextSelectedMeetingFormat != state.meeting.selectedMeetingFormat;
    return state.copyWith(
      meeting: state.meeting.copyWith(
        creatorSelectedMeetingFormat: creatorSelectedMeetingFormat,
        partnerSelectedMeetingFormat: partnerSelectedMeetingFormat,
        selectedMeetingFormat: nextSelectedMeetingFormat,
        lastAgreedMeetingFormat: lastAgreedMeetingFormat,
        dateScenarios: const [],
        selectedScenario: null,
        foundPlaces: shouldClearPlaces ? const [] : state.meeting.foundPlaces,
        filteredPlaces: shouldClearPlaces
            ? const []
            : state.meeting.filteredPlaces,
        centerPoint: shouldClearPlaces ? null : state.meeting.centerPoint,
        routePoints: shouldClearPlaces ? const [] : state.meeting.routePoints,
      ),
    );
  }

  DateNavigationState onScenarioSelected(
    DateNavigationState state, {
    required DateScenario scenario,
  }) {
    return state.copyWith(
      meeting: state.meeting.copyWith(selectedScenario: scenario),
      ui: state.ui.copyWith(lastFailure: null, failureOperation: null),
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
