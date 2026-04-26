import '../../../../core/error/result.dart';
import '../repositories/room_voting_repository.dart';

class VoteForPlace {
  final RoomVotingRepository _repo;
  const VoteForPlace(this._repo);

  Future<Result<void>> call({
    required String roomId,
    required String userId,
    required String placeName,
  }) {
    return _repo.voteForPlace(
      roomId: roomId,
      userId: userId,
      placeName: placeName,
    );
  }
}
