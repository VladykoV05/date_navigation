import '../domain/entities/date_vibe.dart';
import '../domain/entities/place_type.dart';

class FormatChipOption {
  const FormatChipOption({
    required this.id,
    required this.placeType,
    required this.overpassSelectors,
    required this.nominatimQueries,
    this.relevanceBonus = 0.0,
  });

  final String id;
  final PlaceType? placeType;
  final List<String> overpassSelectors;
  final List<String> nominatimQueries;
  final double relevanceBonus;
}

class FormatChipConfig {
  static const List<FormatChipOption> _foodOptions = [
    FormatChipOption(
      id: 'all',
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'cafe',
      placeType: PlaceType.cafe,
      overpassSelectors: ['node["amenity"="cafe"]', 'way["amenity"="cafe"]'],
      nominatimQueries: ['cafe'],
      relevanceBonus: 0.06,
    ),
    FormatChipOption(
      id: 'restaurant',
      placeType: PlaceType.restaurant,
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
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'cinema',
      placeType: PlaceType.cinema,
      overpassSelectors: [
        'node["amenity"="cinema"]',
        'way["amenity"="cinema"]',
      ],
      nominatimQueries: ['cinema'],
      relevanceBonus: 0.07,
    ),
    FormatChipOption(
      id: 'museum',
      placeType: PlaceType.museum,
      overpassSelectors: [
        'node["tourism"="museum"]',
        'way["tourism"="museum"]',
      ],
      nominatimQueries: ['museum'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'gallery',
      placeType: PlaceType.gallery,
      overpassSelectors: [
        'node["tourism"="gallery"]',
        'way["tourism"="gallery"]',
      ],
      nominatimQueries: ['gallery'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'theatre',
      placeType: PlaceType.theatre,
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
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'park',
      placeType: PlaceType.park,
      overpassSelectors: ['node["leisure"="park"]', 'way["leisure"="park"]'],
      nominatimQueries: ['park'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'viewpoint',
      placeType: PlaceType.viewpoint,
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
      placeType: null,
      overpassSelectors: [],
      nominatimQueries: [],
    ),
    FormatChipOption(
      id: 'fitness_centre',
      placeType: PlaceType.fitnessCentre,
      overpassSelectors: [
        'node["leisure"="fitness_centre"]',
        'way["leisure"="fitness_centre"]',
      ],
      nominatimQueries: ['fitness_centre'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'sports_centre',
      placeType: PlaceType.sportsCentre,
      overpassSelectors: [
        'node["leisure"="sports_centre"]',
        'way["leisure"="sports_centre"]',
      ],
      nominatimQueries: ['sports_centre'],
      relevanceBonus: 0.08,
    ),
    FormatChipOption(
      id: 'swimming_pool',
      placeType: PlaceType.swimmingPool,
      overpassSelectors: [
        'node["leisure"="swimming_pool"]',
        'way["leisure"="swimming_pool"]',
      ],
      nominatimQueries: ['swimming_pool'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'ice_rink',
      placeType: PlaceType.iceRink,
      overpassSelectors: [
        'node["leisure"="ice_rink"]',
        'way["leisure"="ice_rink"]',
      ],
      nominatimQueries: ['ice_rink'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'active_racket',
      placeType: PlaceType.activeRacket,
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
      placeType: PlaceType.activeTeam,
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
      placeType: PlaceType.activeClimb,
      overpassSelectors: [
        'node["sport"~"climbing|bouldering"]',
        'way["sport"~"climbing|bouldering"]',
      ],
      nominatimQueries: ['climbing', 'bouldering'],
      relevanceBonus: 0.10,
    ),
    FormatChipOption(
      id: 'active_dance',
      placeType: PlaceType.activeDance,
      overpassSelectors: ['node["sport"="dance"]', 'way["sport"="dance"]'],
      nominatimQueries: ['dance'],
      relevanceBonus: 0.09,
    ),
    FormatChipOption(
      id: 'active_mind_body',
      placeType: PlaceType.activeMindBody,
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
    ).map((option) => option.placeType?.wireValue).whereType<String>().toSet();
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
    final parsedType = PlaceType.tryParse(type);
    if (parsedType == null) return 0.0;
    for (final option in optionsFor(format)) {
      if (option.placeType == parsedType) return option.relevanceBonus;
    }
    return 0.0;
  }

  static List<FormatChipOption> optionsForWire(String? wireValue) {
    if (wireValue == null) return const [];
    return optionsFor(MeetingFormat.fromWireValue(wireValue));
  }
}
