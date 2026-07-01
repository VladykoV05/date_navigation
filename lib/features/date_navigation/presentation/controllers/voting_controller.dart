import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/voting_decisions.dart';
import '../../application/actions/proposal_actions.dart';
import '../../application/actions/vote_scenario_actions.dart';
import '../../application/state_transitions/meeting_interaction_transitions.dart';
import '../../application/services/date_assistant_service.dart';
import '../../application/services/room_interaction_service.dart';
import '../../application/state/date_navigation_state.dart';

typedef VotingStateReader = DateNavigationState Function();
typedef VotingStateWriter = void Function(DateNavigationState state);
typedef VotingGuard = bool Function(String operation);
typedef VotingUserIdRequirement = String? Function(String operation);
typedef VotingFailureWriter = void Function(Failure failure, String operation);

class VotingController {
  const VotingController({
    required RoomInteractionService roomInteraction,
    required DateAssistantService dateAssistant,
    required ProposalActions proposalActions,
    required VoteScenarioActions voteScenarioActions,
    required MeetingInteractionTransitions meetingInteraction,
    required VotingStateReader readState,
    required VotingStateWriter writeState,
    required VotingGuard ensureSessionActive,
    required VotingGuard ensureMeetingFormatMatched,
    required VotingUserIdRequirement requireUserId,
    required VotingFailureWriter setFailure,
    required void Function() clearFailure,
    required void Function(bool value) setRoomActionLoading,
  }) : _roomInteraction = roomInteraction,
       _dateAssistant = dateAssistant,
       _proposalActions = proposalActions,
       _voteScenarioActions = voteScenarioActions,
       _meetingInteraction = meetingInteraction,
       _readState = readState,
       _writeState = writeState,
       _ensureSessionActive = ensureSessionActive,
       _ensureMeetingFormatMatched = ensureMeetingFormatMatched,
       _requireUserId = requireUserId,
       _setFailure = setFailure,
       _clearFailure = clearFailure,
       _setRoomActionLoading = setRoomActionLoading;

  final RoomInteractionService _roomInteraction;
  final DateAssistantService _dateAssistant;
  final ProposalActions _proposalActions;
  final VoteScenarioActions _voteScenarioActions;
  final MeetingInteractionTransitions _meetingInteraction;
  final VotingStateReader _readState;
  final VotingStateWriter _writeState;
  final VotingGuard _ensureSessionActive;
  final VotingGuard _ensureMeetingFormatMatched;
  final VotingUserIdRequirement _requireUserId;
  final VotingFailureWriter _setFailure;
  final void Function() _clearFailure;
  final void Function(bool value) _setRoomActionLoading;

  Future<void> voteForPlace(Place place) async {
    if (!_ensureSessionActive('vote')) return;
    if (!_ensureMeetingFormatMatched('vote')) return;
    final uid = _requireUserId('vote');
    if (uid == null) return;
    final command = _voteScenarioActions.buildVoteForPlaceCommand(
      state: _readState(),
      userId: uid,
      place: place,
    );
    if (command == null) return;
    final res = await _roomInteraction.voteForPlace(
      roomId: command.roomId,
      userId: command.userId,
      placeName: command.placeName,
      meetingFormat: command.meetingFormatWireValue,
    );
    _applyInteractionResult(res, 'vote');
  }

  Future<void> proposePlace(Place place) async {
    if (!_ensureSessionActive('proposal')) return;
    if (!_ensureMeetingFormatMatched('proposal')) return;
    final command = _proposalActions.buildProposePlaceCommand(
      state: _readState(),
      place: place,
    );
    if (command == null) return;
    final res = await _roomInteraction.proposePlace(
      roomId: command.roomId,
      authorRole: command.authorRole,
      place: command.place,
      meetingFormat: command.meetingFormatWireValue,
    );
    _applyInteractionResult(res, 'proposal');
  }

  Future<void> respondToProposal(ProposalResponseDecision decision) async {
    if (!_ensureSessionActive('proposal')) return;
    if (!_ensureMeetingFormatMatched('proposal')) return;
    final uid = _requireUserId('proposal');
    if (uid == null) return;
    final command = _proposalActions.buildRespondToProposalCommand(
      state: _readState(),
      decision: decision,
      actedByUserId: uid,
    );
    if (command == null) return;
    final res = await _roomInteraction.respondToProposal(
      roomId: command.roomId,
      decision: command.decision,
      actedByUserId: command.actedByUserId,
      meetingFormat: command.meetingFormatWireValue,
    );
    _applyInteractionResult(res, 'proposal');
  }

  Future<void> selectScenario(DateScenario scenario) async {
    if (!_ensureSessionActive('meeting')) return;
    final uid = _requireUserId('meeting');
    if (uid == null) return;
    final command = _voteScenarioActions.buildSelectScenarioCommand(
      state: _readState(),
      userId: uid,
      scenario: scenario,
    );
    if (command == null) return;
    _setRoomActionLoading(true);
    final result = await _dateAssistant.selectScenario(
      roomId: command.roomId,
      userId: command.userId,
      scenario: command.scenario,
    );
    _setRoomActionLoading(false);
    final failure = _meetingInteraction.mapInteractionFailure(result);
    if (failure != null) {
      _setFailure(failure, 'meeting');
      return;
    }
    _writeState(
      _meetingInteraction.onScenarioSelected(_readState(), scenario: scenario),
    );
  }

  void _applyInteractionResult(Result<void> result, String operation) {
    final failure = _meetingInteraction.mapInteractionFailure(result);
    if (failure != null) {
      _setFailure(failure, operation);
    } else {
      _clearFailure();
    }
  }
}
