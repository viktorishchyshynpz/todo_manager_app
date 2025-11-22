import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/logic/bloc/auth_bloc.dart';
import '../../auth/logic/bloc/auth_event.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Опції налаштувань
  bool _darkMode = false;
  bool _pushNotifications = false;
  bool _emailReminders = false;

  String? _selectedLanguage;

  // ВИДАЛЯЄМО: final user = AuthRepository.instance.currentUser;
  // Ми будемо отримувати юзера через context.read<AuthBloc>() або BlocBuilder

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ініціалізуємо початкове значення мови
    _selectedLanguage ??= AppLocalizations.of(context)!.english;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Отримуємо поточного юзера зі стану блоку
    // select дозволяє слухати тільки зміни юзера, а не всі зміни стану
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final String userEmail = user?.email ?? '';

    final List<String> languages = [l10n.english, l10n.ukrainian];

    if (!languages.contains(_selectedLanguage)) {
      _selectedLanguage = languages.first;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final minSide = min(width, height);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Блок: Зовнішній вигляд
                    _buildSettingsBlock(
                      context: context,
                      title: l10n.appearance,
                      minSide: minSide,
                      width: width,
                      height: height,
                      child: Row(
                        children: [
                          Icon(
                            Icons.dark_mode,
                            size: minSide * 0.07,
                          ),
                          SizedBox(width: width * 0.04),
                          Text(
                            l10n.darkMode,
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: minSide * 0.04,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _darkMode,
                            onChanged: (value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    // Блок: Мова інтерфейсу
                    _buildSettingsBlock(
                      context: context,
                      title: l10n.language,
                      minSide: minSide,
                      width: width,
                      height: height,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedLanguage, // Використовуємо value
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(
                              language,
                              style: textTheme.bodyLarge?.copyWith(
                                fontSize: minSide * 0.04,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                            // TODO: Тут буде виклик SettingsCubit для зміни локалі
                          });
                        },
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    // Блок: Сповіщення
                    _buildSettingsBlock(
                      context: context,
                      title: l10n.notifiacations,
                      minSide: minSide,
                      width: width,
                      height: height,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                l10n.pushNotifications,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontSize: minSide * 0.04,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _pushNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _pushNotifications = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            children: [
                              Text(
                                l10n.emailReminders,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontSize: minSide * 0.04,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _emailReminders,
                                onChanged: (value) {
                                  setState(() {
                                    _emailReminders = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.04),

                    // Кнопка: Зберегти налаштування
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      ),
                      onPressed: () {
                        _saveChanges(l10n);
                      },
                      child: Text(
                        l10n.saveChanges,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: minSide * 0.05,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    // Кнопка: Вийти з акаунту
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      ),
                      onPressed: () {
                        _showLogOutDialog(userEmail, l10n);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.logOut,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: minSide * 0.05,
                            ),
                          ),
                          if (userEmail.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: minSide * 0.035,
                                color: theme.colorScheme.onError,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsBlock({
    required BuildContext context,
    required String title,
    required double minSide,
    required double width,
    required double height,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: minSide * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * 0.015),
            child,
          ],
        ),
      ),
    );
  }

  void _saveChanges(AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.settingsSavedSuccessfully,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showLogOutDialog(String email, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.logOut,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(
            email.isNotEmpty
                ? 'Ви дійсно хочете вийти з акаунту $email?'
                : l10n.areYouSureLogOut,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                // ВИПРАВЛЕНО: Викликаємо подію BLoC замість прямого виклику репо
                context.read<AuthBloc>().add(AuthLogoutRequested());

                if (context.mounted) {
                  Navigator.pop(context);
                  // AuthGate в main.dart автоматично перекине на WelcomeScreen,
                  // але ми також робимо popUntil, щоб очистити стек навігації
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.loggedOutSuccessfully,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                l10n.logOut,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}