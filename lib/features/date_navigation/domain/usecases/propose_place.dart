import '../../../../core/error/result.dart';
import '../entities/voting_decisions.dart';
import '../repositories/room_voting_repository.dart';

class ProposePlace {
  final RoomVotingRepository _repo;
  const ProposePlace(this._repo);

  Future<Result<void>> call({
    required String roomId,
    required String placeName,
    required ProposalAuthorRole authorRole,
    required double lat,
    required double lon,
    String? placeAddress,
    String? placeType,
  }) {
    return _repo.proposePlace(
      roomId: roomId,
      placeName: placeName,
      authorRole: authorRole,
      lat: lat,
      lon: lon,
      placeAddress: placeAddress,
      placeType: placeType,
    );
  }
}
