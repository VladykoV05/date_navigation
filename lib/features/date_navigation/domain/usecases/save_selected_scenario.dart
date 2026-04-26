import '../../../../core/error/result.dart';
import '../entities/date_scenario.dart';
import '../repositories/room_voting_repository.dart';

class SaveSelectedScenario {
  const SaveSelectedScenario(this._repo);

  final RoomVotingRepository _repo;

  Future<Result<void>> call({
    required String roomId,
    required DateScenario scenario,
    required String selectedByUserId,
  }) {
    return _repo.saveSelectedScenario(
      roomId: roomId,
      scenario: scenario.toMap(),
      selectedByUserId: selectedByUserId,
    );
  }
}
