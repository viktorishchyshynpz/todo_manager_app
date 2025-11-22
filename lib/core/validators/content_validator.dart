import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

/// Валідатори, пов'язані з контентом додатку
class ContentValidator {
  const ContentValidator._();

  /// Ліміти для полів
  static const int _maxTitleLength = 50;
  static const int _maxDescriptionLength = 500;
  static const int _maxCategoryNameLength = 30;

  /// Перевірка заголовку завдання
  static String? validateTaskTitle(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.errorTaskTitleEmpty;
    }

    if (value.length > _maxTitleLength) {
      // Ми додаємо (max ...) до локалізованого рядка.
      // В ідеалі це теж варто було б винести в ARB як параметр,
      // але для простоти поки залишимо так.
      return '${l10n.errorTaskTitleTooLong} (max. $_maxTitleLength)';
    }

    return null;
  }

  /// Перевірка опису
  static String? validateTaskDescription(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value != null && value.length > _maxDescriptionLength) {
      return '${l10n.errorTaskDescriptionTooLong} (max. $_maxDescriptionLength)';
    }

    return null;
  }

  /// Перевірка назви категорії
  static String? validateCategoryName(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.errorCategoryNameEmpty;
    }

    if (value.length > _maxCategoryNameLength) {
      return '${l10n.errorCategoryNameTooLong} (max. $_maxCategoryNameLength)';
    }

    return null;
  }
}