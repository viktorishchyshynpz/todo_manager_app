// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ToDo Manager';

  @override
  String get welcomeTitle => 'Welcome to\nToDo Manager';

  @override
  String get myTasks => 'My Tasks';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get settings => 'Settings';

  @override
  String get newTask => 'New Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get categories => 'Categories';

  @override
  String get tasks => 'Tasks';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get welcomeSubtitle =>
      'Manage your tasks\nefficiently and conveniently';

  @override
  String get getStarted => 'Get Started';

  @override
  String get logIn => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveTask => 'Save Task';

  @override
  String get delete => 'Delete';

  @override
  String get logOut => 'Log Out';

  @override
  String get add => 'Add';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get status => 'Status';

  @override
  String get deadline => 'Deadline';

  @override
  String get hintEnterTaskTitle => 'Enter task title';

  @override
  String get hintAddDescription => 'Add description...';

  @override
  String get hintSelectCategory => 'Select Category';

  @override
  String get hintSelectStatus => 'Select Status';

  @override
  String get hintDateMask => 'dd.mm.yy --:--';

  @override
  String get categoryName => 'Category name';

  @override
  String get pressAgainToExit => 'Press again to exit';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully!';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully!';

  @override
  String get pleaseEnterTaskTitle => 'Please enter task title';

  @override
  String get taskUpdatedSuccessfully => 'Task updated successfully!';

  @override
  String get taskDeletedSuccessfully => 'Task deleted successfully!';

  @override
  String get taskSavedSuccessfully => 'Task saved successfully!';

  @override
  String get addCategoryTitle => 'Add Category';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String get deleteTaskTitle => 'Delete Task';

  @override
  String get areYouSureLogOut => 'Are you sure you want to log out?';

  @override
  String confirmDeleteCategory(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String confirmDeleteTask(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String dueWithValue(String due) {
    return 'Due: $due';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryStudy => 'Study';

  @override
  String get categoryHome => 'Home';

  @override
  String get statusNew => 'New';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCanceled => 'Canceled';

  @override
  String get english => 'English';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get errorInvalidEmail => 'Invalid email format';

  @override
  String get errorUserDisabled => 'This user account has been disabled';

  @override
  String get errorUserNotFound => 'No user found with this email';

  @override
  String get errorWrongPassword => 'Incorrect password';

  @override
  String get errorEmailAlreadyInUse => 'This email is already in use';

  @override
  String get errorOperationNotAllowed =>
      'Email/password sign-in is not enabled';

  @override
  String get errorWeakPassword => 'The password is too weak';

  @override
  String get errorInvalidCredential => 'Invalid sign-in credentials';

  @override
  String get errorUnknownAuthError => 'Authentication error occurred';

  @override
  String get errorUnknown =>
      'An unexpected error occurred, please try again later';

  @override
  String get errorAccountDeletion => 'Error deleting account: ';

  @override
  String get errorEmailEmpty => 'Please enter your email';

  @override
  String get errorEmailInvalid => 'Please enter a valid email';

  @override
  String get errorPasswordEmpty => 'Please enter your password';

  @override
  String get errorPasswordTooShort =>
      'Password must be at least 9 characters long';

  @override
  String get errorConfirmPasswordEmpty => 'Please confirm your password';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errorTaskTitleEmpty => 'Please enter a task title';

  @override
  String get errorTaskTitleTooLong => 'Title is too long';

  @override
  String get errorTaskDescriptionTooLong => 'Description is too long';

  @override
  String get errorCategoryNameEmpty => 'Please enter a category name';

  @override
  String get errorCategoryNameTooLong => 'Name is too long';

  @override
  String get emailVerificationAppBar => 'Email Verification';

  @override
  String get emailVerificationHeader => 'Verify your email';

  @override
  String emailVerificationSentTo(String email) {
    return 'We have sent a verification email to $email. Please check your inbox and click the link in the email.';
  }

  @override
  String get emailVerificationTimeLabel => 'Time to verify:';

  @override
  String get emailVerificationTimeExpiredNote =>
      'After the time expires, the account will be automatically deleted';

  @override
  String get emailVerifiedButton => 'I have verified my email';

  @override
  String get resendVerificationButton => 'Resend verification email';

  @override
  String get resendVerificationSuccess => 'Verification email resent!';

  @override
  String get emailNotVerifiedMessage =>
      'Email not verified yet. Please check your inbox.';

  @override
  String get deleteRequiresRecentLogin =>
      'Account deletion requires recent authentication. Please sign in again.';

  @override
  String get emailVerificationExpiredMessage =>
      'Verification time expired. Please sign up again.';

  @override
  String errorWithDetails(String details) {
    return 'Error: $details';
  }

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifiacations => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailReminders => 'Email Reminders';
}
