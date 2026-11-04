/// Canonical place and filter types used across discovery, scoring, and UI.
enum PlaceType {
  cafe('cafe'),
  restaurant('restaurant'),
  diner('diner'),
  coffeeShop('coffee_shop'),
  bar('bar'),
  fastFood('fast_food'),
  cinema('cinema'),
  museum('museum'),
  gallery('gallery'),
  theatre('theatre'),
  park('park'),
  garden('garden'),
  viewpoint('viewpoint'),
  fitnessCentre('fitness_centre'),
  sportsCentre('sports_centre'),
  swimmingPool('swimming_pool'),
  iceRink('ice_rink'),
  sport('sport'),
  activeRacket('active_racket'),
  activeTeam('active_team'),
  activeClimb('active_climb'),
  activeDance('active_dance'),
  activeMindBody('active_mind_body'),
  school('school'),
  university('university'),
  college('college'),
  kindergarten('kindergarten'),
  languageSchool('language_school'),
  musicSchool('music_school'),
  drivingSchool('driving_school'),
  training('training'),
  office('office');

  const PlaceType(this.wireValue);

  final String wireValue;

  static PlaceType? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final normalized = raw.trim().toLowerCase();
    for (final type in PlaceType.values) {
      if (type.wireValue == normalized) return type;
    }
    return null;
  }

  static const natureWalkTypes = {
    PlaceType.park,
    PlaceType.garden,
    PlaceType.viewpoint,
  };

  static const greenAreaTypes = {PlaceType.park, PlaceType.garden};

  bool get isNatureWalk => natureWalkTypes.contains(this);

  bool get isGreenArea => greenAreaTypes.contains(this);

  /// Bonus applied when ranking places by relevance.
  double get relevanceBonus => switch (this) {
    PlaceType.restaurant => 0.08,
    PlaceType.cafe => 0.07,
    PlaceType.bar => 0.05,
    PlaceType.fastFood => 0.03,
    PlaceType.park => 0.06,
    PlaceType.garden => 0.05,
    PlaceType.viewpoint => 0.06,
    PlaceType.fitnessCentre => 0.05,
    PlaceType.sportsCentre => 0.05,
    PlaceType.swimmingPool => 0.05,
    PlaceType.sport => 0.04,
    _ => 0.0,
  };

  /// Bonus applied when balancing distance between two participants.
  double get meetingBalanceBonus => switch (this) {
    PlaceType.restaurant => 0.05,
    PlaceType.cafe => 0.03,
    _ => 0.0,
  };
}
