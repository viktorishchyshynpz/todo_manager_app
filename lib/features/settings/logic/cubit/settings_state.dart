import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isPushEnabled;
  final bool isEmailEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.isPushEnabled = false,
    this.isEmailEnabled = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isPushEnabled,
    bool? isEmailEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isPushEnabled: isPushEnabled ?? this.isPushEnabled,
      isEmailEnabled: isEmailEnabled ?? this.isEmailEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, isPushEnabled, isEmailEnabled];
}