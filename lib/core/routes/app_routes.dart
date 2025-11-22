class AppRoutes {
  AppRoutes._();

  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String manageCategories = '/manage-categories';
  static const String newTask = '/new-task';
  static const String editTask = '/edit-task';
  static const String emailVerification = '/email-verification';
}

/*
import 'package:flutter/material.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/email_verification_screen.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/categories/screens/manage_categories_screen.dart';
import '../../features/tasks/screens/new_task_screen.dart';
import '../../features/tasks/screens/edit_task_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String manageCategories = '/manage-categories';
  static const String newTask = '/new-task';
  static const String editTask = '/edit-task';
  static const String emailVerification = '/email-verification';

  static final Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    settings: (context) => const SettingsScreen(),
    manageCategories: (context) => const ManageCategoriesScreen(),
    newTask: (context) => const NewTaskScreen(),
    emailVerification: (context) => const EmailVerificationScreen(),

    editTask: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        return EditTaskScreen(task: args);
      }
      return const Scaffold(
        body: Center(child: Text('Error: missing task data')),
      );
    },
  };
}
*/