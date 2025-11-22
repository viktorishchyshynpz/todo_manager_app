import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = LightTheme.theme;
  static final ThemeData darkTheme = DarkTheme.theme;
}