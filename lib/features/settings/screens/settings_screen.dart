import 'dart:math';
import 'package:flutter/material.dart';
import '/core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/repositories/auth_repository.dart';

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

  // Зберігаємо вибрану мову.
  // Увага: в ідеалі тут треба зберігати код мови ('en', 'uk'), а не перекладене слово.
  // Але для візуального прикладу залишимо поки так, ініціалізуємо пізніше.
  String? _selectedLanguage;

  final user = AuthRepository.instance.currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ініціалізуємо початкове значення мови, якщо воно ще не вибране
    _selectedLanguage ??= AppLocalizations.of(context)!.english;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final String userEmail = user?.email ?? '';
    final l10n = AppLocalizations.of(context)!; // Коротке посилання для зручності

    // Список формуємо прямо в build, щоб він оновлювався при зміні мови
    final List<String> languages = [l10n.english, l10n.ukrainian];

    // Страховка, якщо вибрана мова раптом не в списку (наприклад, при перемиканні локалі)
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
                      title: l10n.language, // Або l10n.language, якщо додасте в arb
                      minSide: minSide,
                      width: width,
                      height: height,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedLanguage, // Використовуємо value замість initialValue для динамічних змін
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
                            // ТУТ треба буде додати логіку зміни локалі app (через Bloc/Provider)
                          });
                        },
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    // Блок: Сповіщення
                    _buildSettingsBlock(
                      context: context,
                      title: l10n.notifiacations, // Використав заголовок з перекладу
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
                            SizedBox(height: 4),
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
                ? 'Ви дійсно хочете вийти з акаунту $email?' // Тут можна додати localized string з параметром
                : l10n.areYouSureLogOut,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                l10n.cancel,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () async {
                await AuthRepository.instance.signOut();

                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.welcome,
                          (route) => false
                  );

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