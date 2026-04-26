import '../../../../core/error/result.dart';
import '../entities/voting_decisions.dart';
import '../repositories/room_voting_repository.dart';

class RespondToProposal {
  final RoomVotingRepository _repo;
  const RespondToProposal(this._repo);

  Future<Result<void>> call({
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
