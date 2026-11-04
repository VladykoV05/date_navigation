import '../../../../core/error/result.dart';
import '../entities/accepted_proposal_history_draft.dart';
import '../entities/voting_decisions.dart';
import '../repositories/room_place_voting_repository.dart';

class RespondToProposal {
  final RoomPlaceVotingRepository _repo;
  const RespondToProposal(this._repo);

  Future<Result<AcceptedProposalHistoryDraft?>> call({
    required String roomId,
    required ProposalResponseDecision decision,
    required String actedByUserId,
  }) {
    return _repo.respondToProposal(
      roomId: roomId,
      decision: decision,
      actedByUserId: actedByUserId,
    );
  }
}
