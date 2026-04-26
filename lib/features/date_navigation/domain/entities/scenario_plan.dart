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

  Map<String, dynamic> toMap() {
    return {
      'scenarios': scenarios.map((item) => item.toMap()).toList(growable: false),
      if (generatedAt != null) 'generatedAt': generatedAt!.toIso8601String(),
      if (selectedScenarioId != null && selectedScenarioId!.isNotEmpty)
        'selectedScenarioId': selectedScenarioId,
    };
  }

  factory ScenarioPlan.fromMap(Map<String, dynamic> raw) {
    final rawScenarios = raw['scenarios'];
    final scenarios = rawScenarios is List
        ? rawScenarios
              .whereType<Map>()
              .map((item) => DateScenario.fromMap(Map<String, dynamic>.from(item)))
              .where((item) => item.id.isNotEmpty)
              .toList(growable: false)
        : const <DateScenario>[];
    final generatedAtRaw = raw['generatedAt']?.toString();
    return ScenarioPlan(
      scenarios: scenarios,
      generatedAt: generatedAtRaw == null
          ? null
          : DateTime.tryParse(generatedAtRaw),
      selectedScenarioId: raw['selectedScenarioId']?.toString(),
    );
  }
}
