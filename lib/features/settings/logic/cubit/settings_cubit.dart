import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(const SettingsState()) {
    _loadSettings();
  }

  // Завантажуємо збережені дані при старті
  void _loadSettings() {
    final theme = _repository.getThemeMode();
    final locale = _repository.getLocale();
    final push = _repository.getPushEnabled();
    final email = _repository.getEmailEnabled();

    emit(SettingsState(
      themeMode: theme,
      locale: locale,
      isPushEnabled: push,
      isEmailEnabled: email,
    ));
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _repository.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> changeLanguage(String languageCode) async {
    final locale = Locale(languageCode);
    await _repository.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }

  Future<void> togglePush(bool value) async {
    await _repository.setPushEnabled(value);
    emit(state.copyWith(isPushEnabled: value));
  }

  Future<void> toggleEmail(bool value) async {
    await _repository.setEmailEnabled(value);
    emit(state.copyWith(isEmailEnabled: value));
  }
}