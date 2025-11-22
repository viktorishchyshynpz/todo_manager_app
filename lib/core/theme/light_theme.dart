import 'package:flutter/material.dart';
import 'app_colors.dart';

class LightTheme {
  LightTheme._();

  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.black,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      foregroundColor: AppColors.black,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w700,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textGray,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textGray,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.textGray,
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      hintStyle: const TextStyle(color: AppColors.inputHint),
      suffixIconColor: AppColors.black,
      prefixIconColor: AppColors.black,
      iconColor: AppColors.black,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.textGray, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.textGray, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.settingsSectionBackground,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.accent,
      side: const BorderSide(color: AppColors.accent, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
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
        return AppColors.accent;
      }),
      thumbColor: WidgetStateProperty.all(AppColors.white),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.settingsSectionBackground,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: AppColors.accent, width: 1.5),
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
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        fontSize: 20,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        color: AppColors.textGray,
        fontSize: 16,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.white;
      }),
      side: const BorderSide(color: AppColors.textGray, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    iconTheme: const IconThemeData(color: AppColors.black),
    useMaterial3: false,
  );
}