import 'date_scenario.dart';

class ScenarioPlan {
  const ScenarioPlan({
    required this.scenarios,
    this.generatedAt,
    this.selectedScenarioId,
  });

  final List<DateScenario> scenarios;
  final DateTime? generatedAt;
  final String? selectedScenarioId;
}
