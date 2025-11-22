import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

/// Валідатори, які відповідають за перевірку коректності
/// введених користувачем даних при авторизації.
class AuthValidator {
  const AuthValidator._();

  /// Перевірка поля Email
  /// Тепер приймає [context] для доступу до перекладів
  static String? validateEmail(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.errorEmailEmpty;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return l10n.errorEmailInvalid;
    }

    return null;
  }

  /// Перевірка пароля
  static String? validatePassword(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.errorPasswordEmpty;
    }

    if (value.length < 9) {
      return l10n.errorPasswordTooShort;
    }

    return null;
  }

  /// Перевірка підтвердження пароля
  static String? validateConfirmPassword(BuildContext context, String? value, String password) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return l10n.errorConfirmPasswordEmpty;
    }

    if (value != password) {
      return l10n.errorPasswordsDoNotMatch;
    }

    return null;
  }
}