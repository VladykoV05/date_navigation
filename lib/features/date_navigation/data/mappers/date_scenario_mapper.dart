import '../../domain/entities/date_scenario.dart';
import '../../domain/entities/date_vibe.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/scenario_plan.dart';
import '../../domain/entities/scenario_step.dart';

class DateScenarioMapper {
  const DateScenarioMapper._();

  static Map<String, dynamic> stepToFirestore(ScenarioStep step) {
    return {
      'title': step.title,
      'description': step.description,
      if (step.etaMinutes != null) 'etaMinutes': step.etaMinutes,
      if (step.placeName != null && step.placeName!.isNotEmpty)
        'placeName': step.placeName,
    };
  }

  static ScenarioStep stepFromFirestore(Map<String, dynamic> raw) {
    return ScenarioStep(
      title: (raw['title'] ?? '').toString(),
      description: (raw['description'] ?? '').toString(),
      etaMinutes: (raw['etaMinutes'] as num?)?.toInt(),
      placeName: raw['placeName']?.toString(),
    );
  }

  static Map<String, dynamic> placeToFirestore(Place place) {
    return {
      'name': place.name,
      'lat': place.lat,
      'lon': place.lon,
      if (place.address != null) 'address': place.address,
      if (place.type != null) 'type': place.type,
    };
  }

  static Place? placeFromFirestore(dynamic raw) {
    if (raw is! Map) return null;
    return Place(
      name: (raw['name'] ?? '').toString(),
      lat: (raw['lat'] as num?)?.toDouble() ?? 0,
      lon: (raw['lon'] as num?)?.toDouble() ?? 0,
      address: raw['address']?.toString(),
      type: raw['type']?.toString(),
    );
  }

  static Map<String, dynamic> toFirestore(DateScenario scenario) {
    return {
      'id': scenario.id,
      'meetingFormat': scenario.meetingFormat.wireValue,
      'title': scenario.title,
      'description': scenario.description,
      'totalDurationMinutes': scenario.totalDurationMinutes,
      'steps': scenario.steps.map(stepToFirestore).toList(growable: false),
      if (scenario.anchorPlace != null)
        'anchorPlace': placeToFirestore(scenario.anchorPlace!),
    };
  }

  static DateScenario fromFirestore(Map<String, dynamic> raw) {
    final rawSteps = raw['steps'];
    final steps = rawSteps is List
        ? rawSteps
              .whereType<Map>()
              .map((item) => stepFromFirestore(Map<String, dynamic>.from(item)))
              .toList(growable: false)
        : const <ScenarioStep>[];
    return DateScenario(
      id: (raw['id'] ?? '').toString(),
      meetingFormat: MeetingFormat.fromWireValue(
        (raw['meetingFormat'] ?? raw['vibe'] ?? '').toString(),
      ),
      title: (raw['title'] ?? '').toString(),
      description: (raw['description'] ?? '').toString(),
      totalDurationMinutes: (raw['totalDurationMinutes'] as num?)?.toInt() ?? 0,
      steps: steps,
      anchorPlace: placeFromFirestore(raw['anchorPlace']),
    );
  }

  static Map<String, dynamic> planToFirestore(ScenarioPlan plan) {
    return {
      'scenarios': plan.scenarios.map(toFirestore).toList(growable: false),
      if (plan.generatedAt != null)
        'generatedAt': plan.generatedAt!.toIso8601String(),
      if (plan.selectedScenarioId != null &&
          plan.selectedScenarioId!.isNotEmpty)
        'selectedScenarioId': plan.selectedScenarioId,
    };
  }

  static ScenarioPlan planFromFirestore(Map<String, dynamic> raw) {
    final rawScenarios = raw['scenarios'];
    final scenarios = rawScenarios is List
        ? rawScenarios
              .whereType<Map>()
              .map((item) => fromFirestore(Map<String, dynamic>.from(item)))
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
