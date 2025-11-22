import 'package:flutter/material.dart';
import 'app_colors.dart';

class DarkTheme {
  DarkTheme._();

  static final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accentColorDark,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.settingsSectionBackgroundDark,
      onSurface: AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      foregroundColor: AppColors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 28
      ),
      headlineSmall: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 24
      ),
      bodyLarge: TextStyle(
          color: AppColors.textGrayColorDark,
          fontWeight: FontWeight.w600,
          fontSize: 16
      ),
      bodyMedium: TextStyle(
          color: AppColors.textGrayColorDark,
          fontWeight: FontWeight.w500,
          fontSize: 14
      ),
      bodySmall: TextStyle(
          color: AppColors.textGrayColorDark,
          fontWeight: FontWeight.w400,
          fontSize: 12
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.accentColorDark,
      hintStyle: const TextStyle(color: AppColors.inputHintColorDark),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.textGrayColorDark, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.textGrayColorDark, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.settingsSectionBackgroundDark,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.settingsSectionBackgroundDark,
      side: const BorderSide(color: AppColors.accentColorDark, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      secondaryLabelStyle: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.accentColorDark;
      }),
      thumbColor: WidgetStateProperty.all(AppColors.white),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.settingsSectionBackgroundDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: AppColors.accentColorDark, width: 1.5),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.success,
      contentTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
      behavior: SnackBarBehavior.fixed,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.accentColorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        fontSize: 20,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        color: AppColors.taskDetailTextColorDark,
        fontSize: 16,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.accentColorDark;
      }),
      side: const BorderSide(color: AppColors.textGrayColorDark, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    useMaterial3: false,
  );
}