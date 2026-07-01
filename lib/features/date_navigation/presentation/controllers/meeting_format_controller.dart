import 'dart:async';

import '../../../../core/error/failure.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/voting_decisions.dart';
import '../actions/meeting_collaboration_actions.dart';
import '../actions/meeting_format_actions.dart';
import '../services/date_assistant_service.dart';
import '../state_transitions/meeting_interaction_transitions.dart';
import '../runtime/meeting_planner_runtime.dart';
import '../state/date_navigation_state.dart';

typedef MeetingFormatStateReader = DateNavigationState Function();
typedef MeetingFormatStateWriter = void Function(DateNavigationState state);
typedef MeetingFormatGuard = bool Function(String operation);
typedef MeetingFormatUserIdRequirement = String? Function(String operation);
typedef MeetingFormatFailureWriter =
    void Function(Failure failure, String operation);

class MeetingFormatController {
  const MeetingFormatController({
    required DateAssistantService dateAssistant,
    required MeetingPlannerRuntime meetingPlanner,
    required MeetingFormatStateReader readState,
    required MeetingFormatStateWriter writeState,
    required MeetingFormatGuard ensureSessionActive,
    required MeetingFormatUserIdRequirement requireUserId,
    required MeetingFormatFailureWriter setFailure,
    required void Function() clearFailure,
    required void Function(bool value) setRoomActionLoading,
  }) : _dateAssistant = dateAssistant,
       _meetingPlanner = meetingPlanner,
       _readState = readState,
       _writeState = writeState,
       _ensureSessionActive = ensureSessionActive,
       _requireUserId = requireUserId,
       _setFailure = setFailure,
       _clearFailure = clearFailure,
       _setRoomActionLoading = setRoomActionLoading;

  final DateAssistantService _dateAssistant;
  final MeetingPlannerRuntime _meetingPlanner;
  final MeetingFormatStateReader _readState;
  final MeetingFormatStateWriter _writeState;
  final MeetingFormatGuard _ensureSessionActive;
  final MeetingFormatUserIdRequirement _requireUserId;
  final MeetingFormatFailureWriter _setFailure;
  final void Function() _clearFailure;
  final void Function(bool value) _setRoomActionLoading;

  final MeetingFormatActions _meetingFormatActions =
      const MeetingFormatActions();
  final MeetingCollaborationActions _meetingCollaborationActions =
      const MeetingCollaborationActions();
  final MeetingInteractionTransitions _meetingInteraction =
      const MeetingInteractionTransitions();

  void setMeetingFormats(Set<MeetingFormat> formats) {
    unawaited(_setMeetingFormatsInternal(formats));
  }

  Future<void> _setMeetingFormatsInternal(Set<MeetingFormat> formats) async {
    if (!_ensureSessionActive('meeting')) return;
    final state = _readState();
    final roomId = state.room.roomId;
    final uid = _requireUserId('meeting');
    if (roomId == null || uid == null) return;
    final decision = _meetingFormatActions.resolveSetFormatsAction(
      state: state,
      nextFormats: formats,
    );
    switch (decision.type) {
      case MeetingFormatActionType.noop:
        return;
      case MeetingFormatActionType.error:
        _setFailure(decision.failure!, 'meeting');
        return;
      case MeetingFormatActionType.requestRevote:
        final revoteFormats = decision.formats!;
        _setRoomActionLoading(true);
        final result = await _dateAssistant.requestMeetingRevote(
          roomId: roomId,
          userId: uid,
          formats: revoteFormats,
        );
        _setRoomActionLoading(false);
        final failure = _meetingInteraction.mapInteractionFailure(result);
        if (failure != null) {
          _setFailure(failure, 'meeting');
          return;
        }
        _clearFailure();
        return;
      case MeetingFormatActionType.selectFormats:
        final selectedFormats = decision.formats!;
        _setRoomActionLoading(true);
        final result = await _dateAssistant.selectMeetingFormats(
          roomId: roomId,
          userId: uid,
          formats: selectedFormats,
        );
        _setRoomActionLoading(false);
        final failure = _meetingInteraction.mapInteractionFailure(result);
        if (failure != null) {
          _setFailure(failure, 'meeting');
          return;
        }
        _meetingPlanner.resetOnPointsChanged();
        _writeState(
          _meetingInteraction.onMeetingFormatsSubmitted(
            _readState(),
            formats: selectedFormats,
          ),
        );
        return;
      case MeetingFormatActionType.confirmFormat:
        return;
    }
  }

  void confirmMeetingFormat(MeetingFormat format) {
    unawaited(_confirmMeetingFormatInternal(format));
  }

  Future<void> _confirmMeetingFormatInternal(MeetingFormat format) async {
    if (!_ensureSessionActive('meeting')) return;
    final state = _readState();
    final roomId = state.room.roomId;
    final uid = _requireUserId('meeting');
    if (roomId == null || uid == null) return;
    final decision = _meetingFormatActions.resolveConfirmFormatAction(
      state: state,
      format: format,
    );
    switch (decision.type) {
      case MeetingFormatActionType.noop:
        return;
      case MeetingFormatActionType.error:
        _setFailure(decision.failure!, 'meeting');
        return;
      case MeetingFormatActionType.requestRevote:
        final revoteFormats = decision.formats!;
        _setRoomActionLoading(true);
        final revoteResult = await _dateAssistant.requestMeetingRevote(
          roomId: roomId,
          userId: uid,
          formats: revoteFormats,
        );
        _setRoomActionLoading(false);
        final revoteFailure = _meetingInteraction.mapInteractionFailure(
          revoteResult,
        );
        if (revoteFailure != null) {
          _setFailure(revoteFailure, 'meeting');
        } else {
          _clearFailure();
        }
        return;
      case MeetingFormatActionType.confirmFormat:
        final confirmedFormat = decision.format!;
        _setRoomActionLoading(true);
        final result = await _dateAssistant.confirmMeetingFormat(
          roomId: roomId,
          userId: uid,
          format: confirmedFormat,
        );
        _setRoomActionLoading(false);
        final failure = _meetingInteraction.mapInteractionFailure(result);
        if (failure != null) {
          _setFailure(failure, 'meeting');
          return;
        }
        _writeState(
          _meetingInteraction.onMeetingFormatConfirmed(
            _readState(),
            format: confirmedFormat,
          ),
        );
        return;
      case MeetingFormatActionType.selectFormats:
        return;
    }
  }

  void respondMeetingRevote(MeetingRevoteResponseDecision decision) {
    unawaited(_respondMeetingRevoteInternal(decision));
  }

  Future<void> _respondMeetingRevoteInternal(
    MeetingRevoteResponseDecision decision,
  ) async {
    if (!_ensureSessionActive('meeting')) return;
    final state = _readState();
    final roomId = state.room.roomId;
    final uid = _requireUserId('meeting');
    if (roomId == null || uid == null) return;
    if (!_meetingCollaborationActions.canRespondToMeetingRevote(state)) return;
    _setRoomActionLoading(true);
    final result = await _dateAssistant.respondMeetingRevote(
      roomId: roomId,
      userId: uid,
      decision: decision,
    );
    _setRoomActionLoading(false);
    final failure = _meetingInteraction.mapInteractionFailure(result);
    if (failure != null) {
      _setFailure(failure, 'meeting');
      return;
    }
    _clearFailure();
  }

  void applyPartnerMeetingFormatSuggestion() {
    if (!_ensureSessionActive('meeting')) return;
    final merged = _meetingCollaborationActions.resolveMergedFormatsFromPartner(
      _readState(),
    );
    if (merged == null) return;
    setMeetingFormats(merged);
  }
}
