class DateNavigationConfig {
  static const String appUserAgent =
      'DateNavigationApp/1.0 (student@university.by)';

  static const int overpassTimeoutSeconds = 12;
  static const int nominatimTimeoutSeconds = 6;

  static const int overpassMaxRetries = 1;

  static const int placesFallbackLimitPerType = 100;
  static const bool useNominatimPrimary = true;
  static const int placesMaxResults = 5000;
  static const int placesMinDesiredResults = 8;
  static const int placesMaxRadiusMeters = 3000;
  static const int placesMinRadiusMeters = 200;
  static const bool placesUseSoftDiscoveryFallback = false;
  static const int placesDedupeRadiusMeters = 120;
  static const int placesCacheHours = 3;
  static const String placesCacheVersion = 'v4';

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

  static const int dedupePrecision = 5; 
  static const String cacheVersion = 'v1';
}
