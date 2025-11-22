import 'package:flutter/material.dart';

// Константи кольорів, які використовуються в додатку для світлої та темної теми.
class AppColors {
  AppColors._();

  // Загальні кольори
  static const Color primary = Color(0xFF3B82F6);
  static const Color error = Color(0xFFFF0000);
  static const Color success = Color(0xFF2FDB35);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Кольори для світлої теми
  static const Color textGray = Color(0xFF4B5563);
  static const Color inputHint = Color(0xFF9CA3AF);
  static const Color accent = Color(0xFFD1D5DB);
  static const Color taskDetailText = Color(0xFF6B7280);
  static const Color settingsSectionBackground = Color(0xFFF3F4F6);

  // Кольори для темної теми
  static const Color backgroundDark = Color(0xFF121212);
  static const Color textGrayColorDark = Color(0xFF9CA3AF);
  static const Color inputHintColorDark = Color(0xFF6B7280);
  static const Color accentColorDark = Color(0xFF374151);
  static const Color taskDetailTextColorDark = Color(0xFFD1D5DB);
  static const Color settingsSectionBackgroundDark = Color(0xFF1F2937);
}