// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'ToDo Manager';

  @override
  String get welcomeTitle => 'Ласкаво просимо в\nToDo Manager';

  @override
  String get myTasks => 'Мої завдання';

  @override
  String get manageCategories => 'Керування категоріями';

  @override
  String get settings => 'Налаштування';

  @override
  String get newTask => 'Нове завдання';

  @override
  String get editTask => 'Редагувати завдання';

  @override
  String get appearance => 'Вигляд';

  @override
  String get language => 'Мова';

  @override
  String get categories => 'Категорії';

  @override
  String get tasks => 'Завдання';

  @override
  String get welcomeBack => 'З поверненням';

  @override
  String get createYourAccount => 'Створіть акаунт';

  @override
  String get welcomeSubtitle =>
      'Керуйте своїми завданнями\nефективно та зручно';

  @override
  String get getStarted => 'Розпочати';

  @override
  String get logIn => 'Увійти';

  @override
  String get register => 'Реєстрація';

  @override
  String get saveChanges => 'Зберегти зміни';

  @override
  String get saveTask => 'Зберегти завдання';

  @override
  String get delete => 'Видалити';

  @override
  String get logOut => 'Вийти';

  @override
  String get add => 'Додати';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get edit => 'Редагувати';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Підтвердіть пароль';

  @override
  String get title => 'Назва';

  @override
  String get description => 'Опис';

  @override
  String get category => 'Категорія';

  @override
  String get status => 'Статус';

  @override
  String get deadline => 'Термін';

  @override
  String get hintEnterTaskTitle => 'Введіть назву завдання';

  @override
  String get hintAddDescription => 'Додайте опис...';

  @override
  String get hintSelectCategory => 'Оберіть категорію';

  @override
  String get hintSelectStatus => 'Оберіть статус';

  @override
  String get hintDateMask => 'дд.мм.рр --:--';

  @override
  String get categoryName => 'Назва категорії';

  @override
  String get pressAgainToExit => 'Натисніть ще раз, щоб вийти';

  @override
  String get settingsSavedSuccessfully => 'Налаштування збережено!';

  @override
  String get loggedOutSuccessfully => 'Вихід успішний!';

  @override
  String get pleaseEnterTaskTitle => 'Будь ласка, введіть назву';

  @override
  String get taskUpdatedSuccessfully => 'Завдання оновлено!';

  @override
  String get taskDeletedSuccessfully => 'Завдання видалено!';

  @override
  String get taskSavedSuccessfully => 'Завдання збережено!';

  @override
  String get addCategoryTitle => 'Додати категорію';

  @override
  String get editCategoryTitle => 'Редагувати категорію';

  @override
  String get deleteCategoryTitle => 'Видалити категорію';

  @override
  String get deleteTaskTitle => 'Видалити завдання';

  @override
  String get areYouSureLogOut => 'Ви впевнені, що хочете вийти?';

  @override
  String confirmDeleteCategory(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"?';
  }

  @override
  String confirmDeleteTask(String title) {
    return 'Ви впевнені, що хочете видалити \"$title\"?';
  }

  @override
  String dueWithValue(String due) {
    return 'Термін: $due';
  }

  @override
  String get categoryAll => 'Всі';

  @override
  String get categoryWork => 'Робота';

  @override
  String get categoryStudy => 'Навчання';

  @override
  String get categoryHome => 'Дім';

  @override
  String get statusNew => 'Нове';

  @override
  String get statusInProgress => 'В процесі';

  @override
  String get statusCompleted => 'Виконано';

  @override
  String get statusCanceled => 'Скасовано';

  @override
  String get english => 'Англійська';

  @override
  String get ukrainian => 'Українська';

  @override
  String get errorInvalidEmail => 'Невірний формат email';

  @override
  String get errorUserDisabled => 'Цей акаунт заблоковано';

  @override
  String get errorUserNotFound => 'Користувача з таким email не знайдено';

  @override
  String get errorWrongPassword => 'Невірний пароль';

  @override
  String get errorEmailAlreadyInUse => 'Цей email вже використовується';

  @override
  String get errorOperationNotAllowed => 'Вхід через email/пароль вимкнено';

  @override
  String get errorWeakPassword => 'Пароль занадто слабкий';

  @override
  String get errorInvalidCredential => 'Невірні дані для входу';

  @override
  String get errorUnknownAuthError => 'Помилка авторизації';

  @override
  String get errorUnknown => 'Сталася невідома помилка, спробуйте пізніше';

  @override
  String get errorAccountDeletion => 'Помилка видалення акаунту: ';

  @override
  String get errorEmailEmpty => 'Будь ласка, введіть email';

  @override
  String get errorEmailInvalid => 'Введіть коректний email';

  @override
  String get errorPasswordEmpty => 'Будь ласка, введіть пароль';

  @override
  String get errorPasswordTooShort => 'Пароль має бути не менше 9 символів';

  @override
  String get errorConfirmPasswordEmpty => 'Будь ласка, підтвердіть пароль';

  @override
  String get errorPasswordsDoNotMatch => 'Паролі не співпадають';

  @override
  String get errorTaskTitleEmpty => 'Будь ласка, введіть назву завдання';

  @override
  String get errorTaskTitleTooLong => 'Назва занадто довга';

  @override
  String get errorTaskDescriptionTooLong => 'Опис занадто довгий';

  @override
  String get errorCategoryNameEmpty => 'Будь ласка, введіть назву категорії';

  @override
  String get errorCategoryNameTooLong => 'Назва занадто довга';

  @override
  String get emailVerificationAppBar => 'Підтвердження Email';

  @override
  String get emailVerificationHeader => 'Підтвердіть ваш Email';

  @override
  String emailVerificationSentTo(String email) {
    return 'Ми надіслали лист підтвердження на $email. Будь ласка, перевірте пошту та перейдіть за посиланням.';
  }

  @override
  String get emailVerificationTimeLabel => 'Час на підтвердження:';

  @override
  String get emailVerificationTimeExpiredNote =>
      'Після закінчення часу акаунт буде автоматично видалено';

  @override
  String get emailVerifiedButton => 'Я підтвердив пошту';

  @override
  String get resendVerificationButton => 'Надіслати лист знову';

  @override
  String get resendVerificationSuccess => 'Лист підтвердження відправлено!';

  @override
  String get emailNotVerifiedMessage =>
      'Email ще не підтверджено. Перевірте пошту.';

  @override
  String get deleteRequiresRecentLogin =>
      'Для видалення акаунту потрібен повторний вхід. Будь ласка, увійдіть знову.';

  @override
  String get emailVerificationExpiredMessage =>
      'Час верифікації вичерпано. Зареєструйтесь знову.';

  @override
  String errorWithDetails(String details) {
    return 'Помилка: $details';
  }

  @override
  String get alreadyHaveAccount => 'Вже є акаунт? ';

  @override
  String get dontHaveAccount => 'Немає акаунту? ';

  @override
  String get darkMode => 'Темна тема';

  @override
  String get notifiacations => 'Сповіщення';

  @override
  String get pushNotifications => 'Push сповіщення';

  @override
  String get emailReminders => 'Email нагадування';
}
