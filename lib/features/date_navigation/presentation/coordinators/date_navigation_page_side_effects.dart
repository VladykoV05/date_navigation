import '../../../../core/error/failure.dart';
import '../../application/state/date_navigation_state.dart';

/// Side-effect reactions for date navigation page (dialogs / map focus).
class DateNavigationPageSideEffects {
  const DateNavigationPageSideEffects({
    required this.onFailure,
    required this.onCreatorChangedRadius,
    required this.onPeerRadiusSuggestion,
    required this.onPartnerProposal,
    required this.onPartnerRevoteRequest,
    required this.onFocusMyPoint,
    required this.onFocusCenter,
    required this.onFocusFinalVenue,
  });

  final void Function(Failure failure) onFailure;
  final void Function(int radiusMeters) onCreatorChangedRadius;
  final void Function(int radiusMeters) onPeerRadiusSuggestion;
  final void Function({
    required String placeName,
    String? placeAddress,
    String? placeType,
  })
  onPartnerProposal;
  final void Function() onPartnerRevoteRequest;
  final void Function(DateNavigationState next) onFocusMyPoint;
  final void Function(DateNavigationState next) onFocusCenter;
  final void Function(DateNavigationState next) onFocusFinalVenue;

  void handle(DateNavigationState? previous, DateNavigationState next) {
    if (next.ui.lastFailure != null &&
        next.ui.lastFailure != previous?.ui.lastFailure) {
      onFailure(next.ui.lastFailure!);
    }
    if (next.meeting.creatorChangedRadiusTo != null &&
        next.meeting.creatorChangedRadiusTo !=
            previous?.meeting.creatorChangedRadiusTo &&
        !next.room.isCreator) {
      onCreatorChangedRadius(next.meeting.creatorChangedRadiusTo!);
    }

    final nextPeerSuggestedRadius = next.meeting.peerSuggestedRadius;
    final prevPeerSuggestedRadius = previous?.meeting.peerSuggestedRadius;
    if (nextPeerSuggestedRadius != null &&
        nextPeerSuggestedRadius > 0 &&
        nextPeerSuggestedRadius != prevPeerSuggestedRadius) {
      onPeerRadiusSuggestion(nextPeerSuggestedRadius);
    }

    final myRole = next.room.isCreator ? 'creator' : 'partner';
    final isPendingPartnerProposal =
        next.voting.proposalPlaceName != null &&
        (next.voting.proposalStatus?.isPending ?? false) &&
        next.meeting.finalChoiceName == null &&
        next.voting.proposalByRole != myRole;
    final proposalJustChanged =
        next.voting.proposalPlaceName != previous?.voting.proposalPlaceName ||
        next.voting.proposalStatus != previous?.voting.proposalStatus ||
        next.voting.proposalByRole != previous?.voting.proposalByRole;
    if (isPendingPartnerProposal && proposalJustChanged) {
      onPartnerProposal(
        placeName: next.voting.proposalPlaceName!,
        placeAddress: next.voting.proposalPlaceAddress,
        placeType: next.voting.proposalPlaceType,
      );
    }

    final isPendingPartnerRevoteRequest =
        (next.meeting.meetingRevoteRequestStatus?.isPending ?? false) &&
        next.meeting.meetingRevoteRequestByRole != null &&
        next.meeting.meetingRevoteRequestByRole != myRole;
    final revoteRequestJustChanged =
        next.meeting.meetingRevoteRequestStatus !=
            previous?.meeting.meetingRevoteRequestStatus ||
        next.meeting.meetingRevoteRequestByRole !=
            previous?.meeting.meetingRevoteRequestByRole;
    if (isPendingPartnerRevoteRequest && revoteRequestJustChanged) {
      onPartnerRevoteRequest();
    }

    final hasAllPoints =
        next.room.point1 != null &&
        next.room.point2 != null &&
        next.meeting.centerPoint != null;
    final myPrevPoint = previous?.myPoint(previous.room.isCreator);
    final myNextPoint = next.myPoint(next.room.isCreator);
    final myPointChanged =
        myNextPoint != null &&
        (myPrevPoint == null ||
            myPrevPoint.latitude != myNextPoint.latitude ||
            myPrevPoint.longitude != myNextPoint.longitude);
    if (myPointChanged && next.meeting.centerPoint == null) {
      onFocusMyPoint(next);
    }
    if (hasAllPoints &&
        next.meeting.centerPoint != previous?.meeting.centerPoint) {
      onFocusCenter(next);
    }
    final nextFinalChoicePlace = next.meeting.finalChoicePlace;
    final prevFinalChoicePlace = previous?.meeting.finalChoicePlace;
    final nextChoice = next.meeting.finalChoiceName;
    final prevChoice = previous?.meeting.finalChoiceName;
    if (nextFinalChoicePlace != null &&
        (prevFinalChoicePlace == null ||
            prevFinalChoicePlace.lat != nextFinalChoicePlace.lat ||
            prevFinalChoicePlace.lon != nextFinalChoicePlace.lon ||
            prevChoice != nextChoice)) {
      onFocusFinalVenue(next);
    }
  }
}
