import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_preferences.dart';

final localePreferencesProvider = Provider<LocalePreferences>(
  (ref) => LocalePreferences(),
);

final appLocaleProvider = AsyncNotifierProvider<AppLocaleController, Locale?>(
  AppLocaleController.new,
);

class AppLocaleController extends AsyncNotifier<Locale?> {
  @override
  Future<Locale?> build() =>
      ref.read(localePreferencesProvider).readSavedLocale();

  Future<void> setLocale(Locale locale) async {
    await ref.read(localePreferencesProvider).saveLocale(locale);
    state = AsyncData(locale);
  }
}
