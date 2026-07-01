import '../state/date_navigation_state.dart';

class PartnerFallbackFlow {
  const PartnerFallbackFlow();

  bool canRun({
    required DateNavigationState state,
    required bool isPartnerFallbackInFlight,
  }) {
    if (state.room.isClosed) return false;
    if (state.meeting.selectedMeetingFormat == null) return false;
    if (isPartnerFallbackInFlight || state.room.isCreator) return false;
    final finalChoice = state.meeting.finalChoiceName;
    if (finalChoice != null && finalChoice.isNotEmpty) return false;
    return true;
  }

  bool hasVenueLock(DateNavigationState state) {
    final finalChoice = state.meeting.finalChoiceName;
    return finalChoice != null && finalChoice.isNotEmpty;
  }
}
