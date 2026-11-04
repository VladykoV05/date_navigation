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
}
