import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ToDo Manager'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nToDo Manager'**
  String get welcomeTitle;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get myTasks;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your tasks\nefficiently and conveniently'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveTask.
  ///
  /// In en, this message translates to:
  /// **'Save Task'**
  String get saveTask;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @hintEnterTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter task title'**
  String get hintEnterTaskTitle;

  /// No description provided for @hintAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Add description...'**
  String get hintAddDescription;

  /// No description provided for @hintSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get hintSelectCategory;

  /// No description provided for @hintSelectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get hintSelectStatus;

  /// No description provided for @hintDateMask.
  ///
  /// In en, this message translates to:
  /// **'dd.mm.yy --:--'**
  String get hintDateMask;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @pressAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit'**
  String get pressAgainToExit;

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSavedSuccessfully;

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully!'**
  String get loggedOutSuccessfully;

  /// No description provided for @pleaseEnterTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter task title'**
  String get pleaseEnterTaskTitle;

  /// No description provided for @taskUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully!'**
  String get taskUpdatedSuccessfully;

  /// No description provided for @taskDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully!'**
  String get taskDeletedSuccessfully;

  /// No description provided for @taskSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task saved successfully!'**
  String get taskSavedSuccessfully;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategoryTitle;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryTitle;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategoryTitle;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesYet;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskTitle;

  /// No description provided for @areYouSureLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogOut;

  /// No description provided for @areYouSureLogOutFrom.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of {email}?'**
  String areYouSureLogOutFrom(String email);

  /// No description provided for @confirmDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteCategory(String name);

  /// No description provided for @confirmDeleteTask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String confirmDeleteTask(String title);

  /// No description provided for @dueWithValue.
  ///
  /// In en, this message translates to:
  /// **'Due: {due}'**
  String dueWithValue(String due);

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get categoryStudy;

  /// No description provided for @categoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get categoryHome;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get statusCanceled;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @ukrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get ukrainian;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get errorInvalidEmail;

  /// No description provided for @errorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user account has been disabled'**
  String get errorUserDisabled;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get errorWrongPassword;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Email/password sign-in is not enabled'**
  String get errorOperationNotAllowed;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid sign-in credentials'**
  String get errorInvalidCredential;

  /// No description provided for @errorUnknownAuthError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error occurred'**
  String get errorUnknownAuthError;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred, please try again later'**
  String get errorUnknown;

  /// No description provided for @errorAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: '**
  String get errorAccountDeletion;

  /// No description provided for @errorEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errorEmailEmpty;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get errorPasswordEmpty;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 9 characters long'**
  String get errorPasswordTooShort;

  /// No description provided for @errorConfirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get errorConfirmPasswordEmpty;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @errorTaskTitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task title'**
  String get errorTaskTitleEmpty;

  /// No description provided for @errorTaskTitleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Title is too long'**
  String get errorTaskTitleTooLong;

  /// No description provided for @errorTaskDescriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description is too long'**
  String get errorTaskDescriptionTooLong;

  /// No description provided for @errorCategoryNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get errorCategoryNameEmpty;

  /// No description provided for @errorCategoryNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get errorCategoryNameTooLong;

  /// No description provided for @emailVerificationAppBar.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerificationAppBar;

  /// No description provided for @emailVerificationHeader.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get emailVerificationHeader;

  /// No description provided for @emailVerificationSentTo.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification email to {email}. Please check your inbox and click the link in the email.'**
  String emailVerificationSentTo(String email);

  /// No description provided for @emailVerificationTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time to verify:'**
  String get emailVerificationTimeLabel;

  /// No description provided for @emailVerificationTimeExpiredNote.
  ///
  /// In en, this message translates to:
  /// **'After the time expires, the account will be automatically deleted'**
  String get emailVerificationTimeExpiredNote;

  /// No description provided for @emailVerifiedButton.
  ///
  /// In en, this message translates to:
  /// **'I have verified my email'**
  String get emailVerifiedButton;

  /// No description provided for @resendVerificationButton.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get resendVerificationButton;

  /// No description provided for @resendVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification email resent!'**
  String get resendVerificationSuccess;

  /// No description provided for @emailNotVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Please check your inbox.'**
  String get emailNotVerifiedMessage;

  /// No description provided for @deleteRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Account deletion requires recent authentication. Please sign in again.'**
  String get deleteRequiresRecentLogin;

  /// No description provided for @emailVerificationExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Verification time expired. Please sign up again.'**
  String get emailVerificationExpiredMessage;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorWithDetails(String details);

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailReminders.
  ///
  /// In en, this message translates to:
  /// **'Email Reminders'**
  String get emailReminders;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
