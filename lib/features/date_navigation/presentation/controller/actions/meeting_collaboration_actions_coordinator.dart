import '../../../domain/entities/date_vibe.dart';
import '../../state/date_navigation_state.dart';

class MeetingCollaborationActionsCoordinator {
  const MeetingCollaborationActionsCoordinator();

  double? resolvePartnerSuggestedRadius(DateNavigationState state) {
    final suggested = state.peerSuggestedRadius;
    if (suggested == null || suggested <= 0) return null;
    return suggested.toDouble();
  }

  bool canRespondToMeetingRevote(DateNavigationState state) {
    return state.meetingRevoteRequestStatus?.isPending ?? false;
  }

  Set<MeetingFormat>? resolveMergedFormatsFromPartner(
    DateNavigationState state,
  ) {
    final partnerFormats = state.isCreator
        ? state.partnerMeetingFormats
        : state.creatorMeetingFormats;
    if (partnerFormats.isEmpty) return null;
    final myFormats = state.isCreator
        ? state.creatorMeetingFormats
        : state.partnerMeetingFormats;
    return {...myFormats, ...partnerFormats};
  }
}
