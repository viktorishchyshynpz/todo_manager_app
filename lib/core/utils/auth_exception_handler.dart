import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

class AuthExceptionHandler {
  static String generateErrorMessage(BuildContext context, String errorCode) {
    final l10n = AppLocalizations.of(context)!;

    switch (errorCode) {
      case 'invalid-email':
        return l10n.errorInvalidEmail;
      case 'user-disabled':
        return l10n.errorUserDisabled;
      case 'user-not-found':
        return l10n.errorUserNotFound;
      case 'wrong-password':
        return l10n.errorWrongPassword;
      case 'email-already-in-use':
        return l10n.errorEmailAlreadyInUse;
      case 'operation-not-allowed':
        return l10n.errorOperationNotAllowed;
      case 'weak-password':
        return l10n.errorWeakPassword;
      case 'invalid-credential':
        return l10n.errorInvalidCredential;
      case 'unknown-error':
        return l10n.errorUnknown;
      default:
      // Якщо код невідомий, показуємо загальну помилку з деталями
        return l10n.errorWithDetails(errorCode);
    }
  }
}