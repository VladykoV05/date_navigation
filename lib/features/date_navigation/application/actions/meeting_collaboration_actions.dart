import '../../domain/entities/date_vibe.dart';
import '../state/date_navigation_state.dart';

class MeetingCollaborationActions {
  const MeetingCollaborationActions();

  double? resolvePartnerSuggestedRadius(DateNavigationState state) {
    final suggested = state.meeting.peerSuggestedRadius;
    if (suggested == null || suggested <= 0) return null;
    return suggested.toDouble();
  }

  bool canRespondToMeetingRevote(DateNavigationState state) {
    return state.meeting.meetingRevoteRequestStatus?.isPending ?? false;
  }

  Set<MeetingFormat>? resolveMergedFormatsFromPartner(
    DateNavigationState state,
  ) {
    final partnerFormats = state.room.isCreator
        ? state.meeting.partnerMeetingFormats
        : state.meeting.creatorMeetingFormats;
    if (partnerFormats.isEmpty) return null;
    final myFormats = state.room.isCreator
        ? state.meeting.creatorMeetingFormats
        : state.meeting.partnerMeetingFormats;
    return {...myFormats, ...partnerFormats};
  }
}
