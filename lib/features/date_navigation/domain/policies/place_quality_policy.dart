/// Product rules for filtering and deduplicating discovered places.
class PlaceQualityPolicy {
  const PlaceQualityPolicy._();

  static const int dedupeRadiusMeters = 120;

  static const Set<String> blockedPlaceTypes = {
    'school',
    'university',
    'college',
    'kindergarten',
    'language_school',
    'music_school',
    'driving_school',
    'training',
    'office',
  };

  static const List<String> blockedPlaceNameParts = [
    'образователь',
    'учебн',
    'школа',
    'университет',
    'колледж',
    'лицей',
    'гимназ',
    'курсы',
    'репетитор',
    'офис',
    'бизнес-центр',
    'центр услуг',
  ];
}
