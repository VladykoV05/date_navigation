import 'dart:ui';

/// Builds HTTP Accept-Language for geocoding / place APIs.
class LocaleHeaders {
  const LocaleHeaders._();

  static String acceptLanguage(Locale? locale) {
    final code = locale?.languageCode.toLowerCase();
    if (code == 'en') {
      return 'en-US,en;q=0.9';
    }
    return 'ru-RU,ru;q=0.9,en;q=0.8';
  }

  /// Cache key segment so EN/RU place names do not collide.
  static String cacheLocaleTag(Locale? locale) {
    final code = locale?.languageCode.toLowerCase();
    return (code == null || code.isEmpty) ? 'ru' : code;
  }
}
