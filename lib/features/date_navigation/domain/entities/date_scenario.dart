import 'date_vibe.dart';
import 'place.dart';
import 'scenario_step.dart';

class DateScenario {
  const DateScenario({
    required this.id,
    required this.meetingFormat,
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
    required this.steps,
    this.anchorPlace,
  });

  final String id;
  final MeetingFormat meetingFormat;
  final String title;
  final String description;
  final int totalDurationMinutes;
  final List<ScenarioStep> steps;
  final Place? anchorPlace;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meetingFormat': meetingFormat.wireValue,
      'title': title,
      'description': description,
      'totalDurationMinutes': totalDurationMinutes,
      'steps': steps.map((step) => step.toMap()).toList(growable: false),
      if (anchorPlace != null)
        'anchorPlace': {
          'name': anchorPlace!.name,
          'lat': anchorPlace!.lat,
          'lon': anchorPlace!.lon,
          if (anchorPlace!.address != null) 'address': anchorPlace!.address,
          if (anchorPlace!.type != null) 'type': anchorPlace!.type,
        },
    };
  }

  factory DateScenario.fromMap(Map<String, dynamic> raw) {
    final rawSteps = raw['steps'];
    final steps = rawSteps is List
        ? rawSteps
              .whereType<Map>()
              .map((item) => ScenarioStep.fromMap(Map<String, dynamic>.from(item)))
              .toList(growable: false)
        : const <ScenarioStep>[];
    final anchorRaw = raw['anchorPlace'];
    final anchorPlace = anchorRaw is Map
        ? Place(
            name: (anchorRaw['name'] ?? '').toString(),
            lat: (anchorRaw['lat'] as num?)?.toDouble() ?? 0,
            lon: (anchorRaw['lon'] as num?)?.toDouble() ?? 0,
            address: anchorRaw['address']?.toString(),
            type: anchorRaw['type']?.toString(),
          )
        : null;
    return DateScenario(
      id: (raw['id'] ?? '').toString(),
      meetingFormat: MeetingFormat.fromWireValue(
        (raw['meetingFormat'] ?? raw['vibe'] ?? '').toString(),
      ),
      title: (raw['title'] ?? '').toString(),
      description: (raw['description'] ?? '').toString(),
      totalDurationMinutes: (raw['totalDurationMinutes'] as num?)?.toInt() ?? 0,
      steps: steps,
      anchorPlace: anchorPlace,
    );
  }
}
