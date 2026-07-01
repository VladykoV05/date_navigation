import '../../../../core/error/failure.dart';
import '../../domain/entities/meeting_point.dart';
import '../../domain/entities/place.dart';
import '../state/date_navigation_state.dart';
import '../state_transitions/meeting_state_transitions.dart';
import './partner_fallback_flow.dart';

class PartnerFallbackSuccessResult {
  const PartnerFallbackSuccessResult({
    required this.nextState,
    required this.shouldClearFailure,
    required this.shouldSaveSnapshot,
    required this.snapshotRoomId,
  });

  final DateNavigationState nextState;
  final bool shouldClearFailure;
  final bool shouldSaveSnapshot;
  final String? snapshotRoomId;
}

class PartnerFallbackFailureResult {
  const PartnerFallbackFailureResult({
    required this.failure,
    this.shouldStopLoading = true,
  });

  final Failure failure;
  final bool shouldStopLoading;
}

class PartnerFallbackResultResolver {
  const PartnerFallbackResultResolver(this._partnerFallback);

  final PartnerFallbackFlow _partnerFallback;
  final MeetingStateTransitions _meetingState = const MeetingStateTransitions();

  PartnerFallbackSuccessResult resolveSuccess({
    required DateNavigationState state,
    required MeetingPoint meeting,
    required List<Place> filteredPlaces,
  }) {
    if (_partnerFallback.hasVenueLock(state)) {
      return PartnerFallbackSuccessResult(
        nextState: state.copyWith(
          ui: state.ui.copyWith(isCalculatingMeeting: false),
        ),
        shouldClearFailure: false,
        shouldSaveSnapshot: false,
        snapshotRoomId: null,
      );
    }
    final nextState = _meetingState.applyMeetingSuccess(
      state: state,
      meeting: meeting,
      filteredPlaces: filteredPlaces,
    );
    final roomId = nextState.room.roomId;
    final shouldSaveSnapshot =
        roomId != null &&
        roomId.isNotEmpty &&
        nextState.room.isCreator &&
        nextState.meeting.selectedMeetingFormat != null;
    return PartnerFallbackSuccessResult(
      nextState: nextState,
      shouldClearFailure: true,
      shouldSaveSnapshot: shouldSaveSnapshot,
      snapshotRoomId: roomId,
    );
  }

  PartnerFallbackFailureResult resolveDomainFailure(Failure failure) {
    return PartnerFallbackFailureResult(failure: failure);
  }

  PartnerFallbackFailureResult resolveUnexpectedFailure() {
    return const PartnerFallbackFailureResult(
      failure: UnknownFailure('Не удалось рассчитать точку встречи'),
    );
  }
}
