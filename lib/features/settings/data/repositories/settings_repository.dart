import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // Ключі для збереження
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale_code';
  static const _pushKey = 'push_enabled';
  static const _emailKey = 'email_enabled';

  // --- Theme ---
  ThemeMode getThemeMode() {
    final themeString = _prefs.getString(_themeKey);
    if (themeString == 'dark') return ThemeMode.dark;
    if (themeString == 'light') return ThemeMode.light;
    return ThemeMode.system; // За замовчуванням
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.system:
      default:
        value = 'system';
    }
    await _prefs.setString(_themeKey, value);
  }

  // --- Locale ---
  Locale getLocale() {
    final code = _prefs.getString(_localeKey);
    if (code == 'uk') return const Locale('uk');
    return const Locale('en'); // За замовчуванням
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  // --- Notifications ---
  bool getPushEnabled() => _prefs.getBool(_pushKey) ?? false;

  Future<void> setPushEnabled(bool value) async {
    await _prefs.setBool(_pushKey, value);
  }

  bool getEmailEnabled() => _prefs.getBool(_emailKey) ?? false;

  Future<void> setEmailEnabled(bool value) async {
    await _prefs.setBool(_emailKey, value);
  }
}