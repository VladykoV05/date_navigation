import '../../../../core/error/result.dart';
import '../entities/date_scenario.dart';

abstract interface class RoomScenarioRepository {
  Future<Result<void>> saveSelectedScenario({
    required String roomId,
    required DateScenario scenario,
    required String selectedByUserId,
  });
}
