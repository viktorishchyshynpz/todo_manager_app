import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  final NotificationService _notificationService = NotificationService.instance;

  SettingsCubit(this._repository) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final theme = _repository.getThemeMode();
    final locale = _repository.getLocale();
    final push = _repository.getPushEnabled();
    final email = _repository.getEmailEnabled(); // Це Local Notifications у твоїй реалізації

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
    // Викликаємо сервіс для підписки/відписки
    await _notificationService.togglePushNotifications(value);
    emit(state.copyWith(isPushEnabled: value));
  }

  Future<void> toggleEmail(bool value) async {
    // Це відповідає за "Local Notifications" в UI
    await _repository.setEmailEnabled(value);

    if (value == false) {
      // Якщо вимкнули - видаляємо всі заплановані
      await _notificationService.cancelAllNotifications();
    } else {
      // Якщо увімкнули - в ідеалі треба пройтись по всіх tasks і запланувати знову.
      // Це можна зробити, якщо передати сюди список завдань, або просто залишити
      // як є (нові завдання будуть плануватися, а старі - при редагуванні).
      // Для повноцінної роботи тут можна викликати подію в TasksBloc, але це порушує ізоляцію.
    }

    emit(state.copyWith(isEmailEnabled: value));
  }
}