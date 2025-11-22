import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Додано для BLoC
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'l10n/app_localizations.dart';

// --- Imports для BLoC та Auth ---
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/logic/bloc/auth_bloc.dart';
import 'features/auth/logic/bloc/auth_event.dart';
import 'features/auth/logic/bloc/auth_state.dart';

// --- Screens ---
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseAnalytics.instance.logEvent(name: 'app_started');

  // 1. Створюємо інстанс репозиторію
  final authRepository = AuthRepository();

  runApp(ToDoApp(authRepository: authRepository));
}

class ToDoApp extends StatelessWidget {
  final AuthRepository authRepository;

  const ToDoApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    // 2. Впроваджуємо Репозиторій через Provider
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        // 3. Створюємо AuthBloc і одразу запускаємо перевірку стану
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        )..add(AuthCheckRequested()),

        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo Manager',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,

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
          locale: const Locale('en'), // Поки що хардкод, в Lab 5 SettingsCubit це змінить

          // 4. ЗАМІСТЬ initialRoute використовуємо home з AuthGate
          // AuthGate сам вирішить, куди направити користувача
          home: const AuthGate(),

          routes: {
            // AppRoutes.welcome видаляємо звідси, бо він обробляється в AuthGate,
            // або залишаємо, якщо потрібна явна навігація
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.settings: (context) => const SettingsScreen(),
            AppRoutes.manageCategories: (context) => const ManageCategoriesScreen(),
            AppRoutes.newTask: (context) => const NewTaskScreen(),
            AppRoutes.emailVerification: (context) => const EmailVerificationScreen(),

            AppRoutes.editTask: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              if (args is Map<String, dynamic>) {
                return EditTaskScreen(task: args);
              }
              return const Scaffold(
                body: Center(child: Text('Error: Task data missing!')),
              );
            },
          },
        ),
      ),
    );
  }
}

/// Цей віджет слухає стан авторизації і показує правильний екран.
/// Це замінює стару логіку `initialRoute: isVerified ? ... : ...`
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // 1. Якщо стан ще не визначено (сплеш скрін)
        if (state.status == AuthStatus.initial || state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Користувач авторизований і пошта підтверджена -> Home
        if (state.status == AuthStatus.authenticated) {
          return const HomeScreen();
        }

        // 3. Користувач авторизований, але пошта НЕ підтверджена -> Verify
        if (state.status == AuthStatus.unverified) {
          return const EmailVerificationScreen();
        }

        // 4. Всі інші варіанти (не авторизований, помилка) -> Welcome
        return const WelcomeScreen();
      },
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/logic/bloc/auth_bloc.dart';

import 'features/tasks/logic/bloc/tasks_bloc.dart';
import 'features/tasks/data/repositories/tasks_repository.dart';

import 'features/categories/logic/bloc/categories_bloc.dart';
import 'features/categories/data/repositories/categories_repository.dart';

import 'features/settings/logic/cubit/settings_cubit.dart';

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseAnalytics.instance.logEvent(name: 'app_started');

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository.instance;
    final user = authRepo.currentUser;

    final bool isVerified = user != null && user.emailVerified;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepo),
        ),
        BlocProvider<TasksBloc>(
          create: (_) => TasksBloc(TasksRepository())..add(LoadTasks()),
        ),
        BlocProvider<CategoriesBloc>(
          create: (_) =>
              CategoriesBloc(CategoriesRepository())..add(LoadCategories()),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ToDo Manager',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.isDark ? ThemeMode.dark : ThemeMode.light,

            locale: settingsState.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('uk'),
            ],

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            initialRoute:
                isVerified ? AppRoutes.home : AppRoutes.welcome,

            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
*/