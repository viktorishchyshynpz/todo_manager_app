import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'l10n/app_localizations.dart';
import 'core/services/notification_service.dart';

// Auth
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/logic/bloc/auth_bloc.dart';
import 'features/auth/logic/bloc/auth_event.dart';
import 'features/auth/logic/bloc/auth_state.dart';

// Settings
import 'features/settings/data/repositories/settings_repository.dart';
import 'features/settings/logic/cubit/settings_cubit.dart';
import 'features/settings/logic/cubit/settings_state.dart';

// Categories
import 'features/categories/data/repositories/categories_repository.dart';
import 'features/categories/logic/bloc/categories_bloc.dart';
import 'features/categories/logic/bloc/categories_event.dart';

// Tasks
import 'features/tasks/data/repositories/tasks_repository.dart';
import 'features/tasks/logic/bloc/tasks_bloc.dart';
import 'features/tasks/logic/bloc/tasks_event.dart';
import 'features/tasks/data/models/task_model.dart';

// Screens
import 'features/auth/screens/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/email_verification_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/categories/screens/manage_categories_screen.dart';
import 'features/tasks/screens/new_task_screen.dart';
import 'features/tasks/screens/edit_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ініціалізуємо базу даних часових поясів на старті
  tz_data.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseAnalytics.instance.logEvent(name: 'app_started');

  final prefs = await SharedPreferences.getInstance();
  final authRepository = AuthRepository();
  final categoriesRepository = CategoriesRepository();
  final tasksRepository = TasksRepository();
  final settingsRepository = SettingsRepository(prefs);

  // Ініціалізація сервісу сповіщень
  await NotificationService.instance.initialize(settingsRepository);

  runApp(ToDoApp(
    authRepository: authRepository,
    categoriesRepository: categoriesRepository,
    tasksRepository: tasksRepository,
    settingsRepository: settingsRepository,
  ));
}

class ToDoApp extends StatelessWidget {
  final AuthRepository authRepository;
  final CategoriesRepository categoriesRepository;
  final TasksRepository tasksRepository;
  final SettingsRepository settingsRepository;

  const ToDoApp({
    super.key,
    required this.authRepository,
    required this.categoriesRepository,
    required this.tasksRepository,
    required this.settingsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: categoriesRepository),
        RepositoryProvider.value(value: tasksRepository),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(
              context.read<SettingsRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return MultiBlocProvider(
              key: ValueKey(authState.user?.uid),
              providers: [
                BlocProvider(
                  create: (context) => CategoriesBloc(
                    repository: context.read<CategoriesRepository>(),
                  )..add(LoadCategories()),
                ),
                BlocProvider(
                  create: (context) => TasksBloc(
                    repository: context.read<TasksRepository>(),
                  )..add(LoadTasks()),
                ),
              ],
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'ToDo Manager',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: settingsState.themeMode,
                    locale: settingsState.locale,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en'),
                      Locale('uk'),
                    ],
                    home: const AuthGate(),
                    routes: {
                      AppRoutes.login: (context) => const LoginScreen(),
                      AppRoutes.register: (context) => const RegisterScreen(),
                      AppRoutes.settings: (context) => const SettingsScreen(),
                      AppRoutes.manageCategories: (context) => const ManageCategoriesScreen(),
                      AppRoutes.newTask: (context) => const NewTaskScreen(),
                      AppRoutes.emailVerification: (context) => const EmailVerificationScreen(),
                      AppRoutes.editTask: (context) {
                        final args = ModalRoute.of(context)?.settings.arguments;
                        if (args is TaskModel) {
                          return EditTaskScreen(task: args);
                        }
                        return const Scaffold(
                          body: Center(child: Text('Error: Task data missing!')),
                        );
                      },
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.initial || state.status == AuthStatus.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.status == AuthStatus.authenticated) {
          return const HomeScreen();
        }
        if (state.status == AuthStatus.unverified) {
          return const EmailVerificationScreen();
        }
        return const WelcomeScreen();
      },
    );
  }
}