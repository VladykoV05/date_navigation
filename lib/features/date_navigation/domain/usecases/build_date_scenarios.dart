import '../entities/date_scenario.dart';
import '../entities/date_vibe.dart';
import '../entities/place.dart';
import '../entities/scenario_step.dart';

class BuildDateScenarios {
  const BuildDateScenarios();

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
        title: _titleForFormat(format, place.name, index),
        description: _descriptionForFormat(format),
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

  String _titleForFormat(MeetingFormat format, String placeName, int index) {
    final variant = index + 1;
    return switch (format) {
      MeetingFormat.food => 'План с кофе или ужином #$variant в $placeName',
      MeetingFormat.culture => 'Культурный вечер #$variant',
      MeetingFormat.walkOnly => 'Прогулочный план #$variant',
      MeetingFormat.active => 'Активный план #$variant',
    };
  }

  String _descriptionForFormat(MeetingFormat format) {
    return switch (format) {
      MeetingFormat.food =>
        'Универсальный формат: можно зайти на кофе или поужинать в одном месте.',
      MeetingFormat.culture =>
        'Формат для впечатлений: кино, выставка или атмосферное культурное место.',
      MeetingFormat.walkOnly =>
        'Спокойный формат без заведения: прогулка по парку или набережной.',
      MeetingFormat.active =>
        'Динамичный формат: спортивная или активная встреча.',
    };
  }

  List<ScenarioStep> _stepsFor(
    MeetingFormat format,
    Place place,
    int duration,
  ) {
    return switch (format) {
      MeetingFormat.food => [
        ScenarioStep(
          title: 'Сбор в заведении',
          description: 'Встречаетесь и выбираете удобный стол.',
          etaMinutes: 15,
          placeName: place.name,
        ),
        ScenarioStep(
          title: 'Еда и общение',
          description:
              'Формат под настроение: кофе-брейк или полноценный ужин.',
          etaMinutes: duration - 15,
          placeName: place.name,
        ),
      ],
      MeetingFormat.culture => [
        ScenarioStep(
          title: 'Встреча у локации',
          description: 'Встречаетесь у выбранного культурного места.',
          etaMinutes: 15,
          placeName: place.name,
        ),
        ScenarioStep(
          title: 'Основная часть',
          description: 'Проводите время вместе и обсуждаете впечатления.',
          etaMinutes: duration - 15,
          placeName: place.name,
        ),
      ],
      MeetingFormat.walkOnly => [
        ScenarioStep(
          title: 'Встреча у стартовой точки',
          description: 'Собираетесь в удобной точке рядом с маршрутом.',
          etaMinutes: 10,
        ),
        ScenarioStep(
          title: 'Прогулка',
          description: 'Гуляете по парку/набережной и общаетесь.',
          etaMinutes: duration - 10,
        ),
      ],
      MeetingFormat.active => [
        ScenarioStep(
          title: 'Сбор на локации',
          description: 'Встречаетесь и готовитесь к активности.',
          etaMinutes: 10,
          placeName: place.name,
        ),
        ScenarioStep(
          title: 'Активная часть',
          description: 'Совместная активность в комфортном темпе.',
          etaMinutes: duration - 10,
          placeName: place.name,
        ),
      ],
    };
  }
}
