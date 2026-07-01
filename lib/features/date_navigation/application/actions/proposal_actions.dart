import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../state/date_navigation_state.dart';

class ProposePlaceCommand {
  const ProposePlaceCommand({
    required this.roomId,
    required this.authorRole,
    required this.place,
    required this.meetingFormatWireValue,
  });

  final String roomId;
  final ProposalAuthorRole authorRole;
  final Place place;
  final String? meetingFormatWireValue;
}

class RespondToProposalCommand {
  const RespondToProposalCommand({
    required this.roomId,
    required this.decision,
    required this.actedByUserId,
    required this.meetingFormatWireValue,
  });

  final String roomId;
  final ProposalResponseDecision decision;
  final String actedByUserId;
  final String? meetingFormatWireValue;
}

class ProposalActions {
  const ProposalActions();

  ProposePlaceCommand? buildProposePlaceCommand({
    required DateNavigationState state,
    required Place place,
  }) {
    final roomId = state.room.roomId;
    if (roomId == null || roomId.isEmpty) return null;
    return ProposePlaceCommand(
      roomId: roomId,
      authorRole: state.room.isCreator
          ? ProposalAuthorRole.creator
          : ProposalAuthorRole.partner,
      place: place,
      meetingFormatWireValue: state.meeting.selectedMeetingFormat?.wireValue,
    );
  }

  RespondToProposalCommand? buildRespondToProposalCommand({
    required DateNavigationState state,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  }) {
    final roomId = state.room.roomId;
    if (roomId == null || roomId.isEmpty) return null;
    if (actedByUserId.isEmpty) return null;
    return RespondToProposalCommand(
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
      meetingFormatWireValue: state.meeting.selectedMeetingFormat?.wireValue,
    );
  }
}
