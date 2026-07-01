import '../domain/entities/date_vibe.dart';

class FormatChipOption {
  const FormatChipOption({
    required this.id,
    required this.label,
    required this.placeType,
    required this.overpassSelectors,
    required this.nominatimQueries,
    this.relevanceBonus = 0.0,
  });

  final String id;
  final String label;
  final String? placeType;
  final List<String> overpassSelectors;
  final List<String> nominatimQueries;
  final double relevanceBonus;
}

class FormatChipConfig {
  static const List<FormatChipOption> _foodOptions = [
    FormatChipOption(
      id: 'all',
      label: 'Все',
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'cafe',
      label: 'Кафе',
      placeType: 'cafe',
      overpassSelectors: ['node["amenity"="cafe"]', 'way["amenity"="cafe"]'],
      nominatimQueries: ['cafe'],
      relevanceBonus: 0.06,
    ),
    FormatChipOption(
      id: 'restaurant',
      label: 'Рестораны',
      placeType: 'restaurant',
      overpassSelectors: [
        'node["amenity"="restaurant"]',
        'way["amenity"="restaurant"]',
      ],
      nominatimQueries: ['restaurant'],
      relevanceBonus: 0.08,
    ),
  ];

  static const List<FormatChipOption> _cultureOptions = [
    FormatChipOption(
      id: 'all',
      label: 'Все',
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'cinema',
      label: 'Кино',
      placeType: 'cinema',
      overpassSelectors: [
        'node["amenity"="cinema"]',
        'way["amenity"="cinema"]',
      ],
      nominatimQueries: ['cinema'],
      relevanceBonus: 0.07,
    ),
    FormatChipOption(
      id: 'museum',
      label: 'Музеи',
      placeType: 'museum',
      overpassSelectors: [
        'node["tourism"="museum"]',
        'way["tourism"="museum"]',
      ],
      nominatimQueries: ['museum'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'gallery',
      label: 'Галереи',
      placeType: 'gallery',
      overpassSelectors: [
        'node["tourism"="gallery"]',
        'way["tourism"="gallery"]',
      ],
      nominatimQueries: ['gallery'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'theatre',
      label: 'Театры',
      placeType: 'theatre',
      overpassSelectors: [
        'node["amenity"="theatre"]',
        'way["amenity"="theatre"]',
      ],
      nominatimQueries: ['theatre'],
      relevanceBonus: 0.07,
    ),
  ];

  static const List<FormatChipOption> _walkOnlyOptions = [
    FormatChipOption(
      id: 'all',
      label: 'Все',
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'park',
      label: 'Парки',
      placeType: 'park',
      overpassSelectors: ['node["leisure"="park"]', 'way["leisure"="park"]'],
      nominatimQueries: ['park'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'viewpoint',
      label: 'Видовые',
      placeType: 'viewpoint',
      overpassSelectors: [
        'node["tourism"="viewpoint"]',
        'way["tourism"="viewpoint"]',
      ],
      nominatimQueries: ['viewpoint'],
      relevanceBonus: 0.08,
    ),
  ];

  static const List<FormatChipOption> _activeOptions = [
    FormatChipOption(
      id: 'all',
      label: 'Все',
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'fitness_centre',
      label: 'Фитнес',
      placeType: 'fitness_centre',
      overpassSelectors: [
        'node["leisure"="fitness_centre"]',
        'way["leisure"="fitness_centre"]',
      ],
      nominatimQueries: ['fitness_centre'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'sports_centre',
      label: 'Спортцентр',
      placeType: 'sports_centre',
      overpassSelectors: [
        'node["leisure"="sports_centre"]',
        'way["leisure"="sports_centre"]',
      ],
      nominatimQueries: ['sports_centre'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'swimming_pool',
      label: 'Бассейн',
      placeType: 'swimming_pool',
      overpassSelectors: [
        'node["leisure"="swimming_pool"]',
        'way["leisure"="swimming_pool"]',
      ],
      nominatimQueries: ['swimming_pool'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'ice_rink',
      label: 'Каток',
      placeType: 'ice_rink',
      overpassSelectors: [
        'node["leisure"="ice_rink"]',
        'way["leisure"="ice_rink"]',
      ],
      nominatimQueries: ['ice_rink'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'active_racket',
      label: 'Ракетки',
      placeType: 'active_racket',
      overpassSelectors: [
        'node["sport"~"tennis|badminton|squash|table_tennis|padel"]',
        'way["sport"~"tennis|badminton|squash|table_tennis|padel"]',
      ],
      nominatimQueries: [
        'tennis',
        'badminton',
        'squash',
        'table_tennis',
        'padel',
      ],
      relevanceBonus: 0.10,
    ),
    FormatChipOption(
      id: 'active_team',
      label: 'Командные',
      placeType: 'active_team',
      overpassSelectors: [
        'node["sport"~"football|basketball|volleyball|futsal|handball"]',
        'way["sport"~"football|basketball|volleyball|futsal|handball"]',
      ],
      nominatimQueries: [
        'football',
        'basketball',
        'volleyball',
        'futsal',
        'handball',
      ],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'active_climb',
      label: 'Скалолаз.',
      placeType: 'active_climb',
      overpassSelectors: [
        'node["sport"~"climbing|bouldering"]',
        'way["sport"~"climbing|bouldering"]',
      ],
      nominatimQueries: ['climbing', 'bouldering'],
      relevanceBonus: 0.10,
    ),
    FormatChipOption(
      id: 'active_dance',
      label: 'Танцы',
      placeType: 'active_dance',
      overpassSelectors: ['node["sport"="dance"]', 'way["sport"="dance"]'],
      nominatimQueries: ['dance'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'active_mind_body',
      label: 'Йога',
      placeType: 'active_mind_body',
      overpassSelectors: [
        'node["sport"~"yoga|pilates"]',
        'way["sport"~"yoga|pilates"]',
      ],
      nominatimQueries: ['yoga', 'pilates'],
      relevanceBonus: 0.08,
    ),
  ];

  static const Map<MeetingFormat, List<FormatChipOption>> _byFormat = {
    MeetingFormat.food: _foodOptions,
    MeetingFormat.culture: _cultureOptions,
    MeetingFormat.walkOnly: _walkOnlyOptions,
    MeetingFormat.active: _activeOptions,
  };

  static List<FormatChipOption> optionsFor(MeetingFormat? format) {
    final selected = format ?? MeetingFormat.food;
    return _byFormat[selected] ?? _foodOptions;
  }

  static Set<String> allowedTypesFor(MeetingFormat format) {
    return optionsFor(
      format,
    ).map((option) => option.placeType).whereType<String>().toSet();
  }

  static List<String> overpassSelectorsFor(MeetingFormat format) {
    final selectors = <String>[];
    for (final option in optionsFor(format)) {
      selectors.addAll(option.overpassSelectors);
    }
    return selectors.toSet().toList(growable: false);
  }

  static List<String> nominatimQueriesFor(MeetingFormat format) {
    final queries = <String>[];
    for (final option in optionsFor(format)) {
      queries.addAll(option.nominatimQueries);
    }
    return queries.toSet().toList(growable: false);
  }

  static double bonusForType(MeetingFormat format, String? type) {
    if (type == null) return 0.0;
    for (final option in optionsFor(format)) {
      if (option.placeType == type) return option.relevanceBonus;
    }
    return 0.0;
  }

  static List<FormatChipOption> optionsForWire(String? wireValue) {
    if (wireValue == null) return const [];
    return optionsFor(MeetingFormat.fromWireValue(wireValue));
  }

  static String formatLabel(MeetingFormat format) {
    return switch (format) {
      MeetingFormat.food => 'Кофе или ужин',
      MeetingFormat.culture => 'Культура и впечатления',
      MeetingFormat.walkOnly => 'Просто прогулка',
      MeetingFormat.active => 'Активный формат',
    };
  }
}
