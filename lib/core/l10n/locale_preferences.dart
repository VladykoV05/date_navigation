import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalePreferences {
  static const _localeKey = 'app_locale_v1';

  Future<Locale?> readSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
