import '../entities/date_scenario.dart';
import '../entities/date_vibe.dart';
import '../entities/place.dart';
import '../entities/scenario_step.dart';
import '../services/scenario_copy_catalog.dart';

class BuildDateScenarios {
  const BuildDateScenarios(this._copy);

  final ScenarioCopyCatalog _copy;

  List<DateScenario> call({
    required MeetingFormat format,
    required List<Place> places,
  }) {
    final anchors = places.take(3).toList(growable: false);
    if (anchors.isEmpty) return const [];

    return List<DateScenario>.generate(anchors.length, (index) {
      final place = anchors[index];
      final id =
          '${format.wireValue}_${index + 1}_${place.name.hashCode.abs()}';
      final duration = _durationForFormat(format, index);
      return DateScenario(
        id: id,
        meetingFormat: format,
        title: _copy.title(
          format: format,
          variant: index + 1,
          placeName: place.name,
        ),
        description: _copy.description(format),
        totalDurationMinutes: duration,
        anchorPlace: place,
        steps: _stepsFor(format, place, duration),
      );
    });
  }

  int _durationForFormat(MeetingFormat format, int index) {
    return switch (format) {
      MeetingFormat.food => 75 + index * 15,
      MeetingFormat.culture => 90 + index * 10,
      MeetingFormat.walkOnly => 60 + index * 10,
      MeetingFormat.active => 70 + index * 15,
    };
  }

  List<ScenarioStep> _stepsFor(
    MeetingFormat format,
    Place place,
    int duration,
  ) {
    final firstDuration = switch (format) {
      MeetingFormat.food || MeetingFormat.culture => 15,
      MeetingFormat.walkOnly || MeetingFormat.active => 10,
    };
    return List<ScenarioStep>.generate(2, (stepIndex) {
      final copy = _copy.step(format: format, stepIndex: stepIndex);
      return ScenarioStep(
        title: copy.$1,
        description: copy.$2,
        etaMinutes: stepIndex == 0 ? firstDuration : duration - firstDuration,
        placeName: format == MeetingFormat.walkOnly ? null : place.name,
      );
    }, growable: false);
  }
}
