import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';

// Bloc Imports
import '../../auth/logic/bloc/auth_bloc.dart';
import '../../auth/logic/bloc/auth_event.dart';
import '../logic/cubit/settings_cubit.dart';
import '../logic/cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Перетворили на Stateless, бо стан тепер в Cubit

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Отримуємо email з AuthBloc
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final String userEmail = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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

            // Використовуємо BlocBuilder для SettingsCubit
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                // Визначаємо поточні значення зі стану
                final isDark = state.themeMode == ThemeMode.dark;
                final currentLangCode = state.locale.languageCode;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Блок: Зовнішній вигляд ---
                        _buildSettingsBlock(
                          context: context,
                          title: l10n.appearance,
                          minSide: minSide,
                          width: width,
                          height: height,
                          child: Row(
                            children: [
                              Icon(Icons.dark_mode, size: minSide * 0.07),
                              SizedBox(width: width * 0.04),
                              Text(
                                l10n.darkMode,
                                style: textTheme.bodyLarge?.copyWith(fontSize: minSide * 0.04),
                              ),
                              const Spacer(),
                              Switch(
                                value: isDark,
                                onChanged: (value) {
                                  // Миттєва зміна теми
                                  context.read<SettingsCubit>().toggleTheme(value);
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.02),

                        // --- Блок: Мова ---
                        _buildSettingsBlock(
                          context: context,
                          title: l10n.language,
                          minSide: minSide,
                          width: width,
                          height: height,
                          child: DropdownButtonFormField<String>(
                            // Важливо: перевіряємо чи поточна мова є в списку, інакше 'en'
                            initialValue: ['en', 'uk'].contains(currentLangCode) ? currentLangCode : 'en',
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: [
                              DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                              DropdownMenuItem(value: 'uk', child: Text(l10n.ukrainian)),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                // Миттєва зміна мови
                                context.read<SettingsCubit>().changeLanguage(value);
                              }
                            },
                          ),
                        ),

                        SizedBox(height: height * 0.02),

                        // --- Блок: Сповіщення ---
                        _buildSettingsBlock(
                          context: context,
                          title: l10n.notifications,
                          minSide: minSide,
                          width: width,
                          height: height,
                          child: Column(
                            children: [
                              _buildSwitchRow(
                                label: l10n.pushNotifications,
                                value: state.isPushEnabled,
                                onChanged: (val) => context.read<SettingsCubit>().togglePush(val),
                                textTheme: textTheme,
                                minSide: minSide,
                              ),
                              SizedBox(height: height * 0.01),
                              _buildSwitchRow(
                                label: l10n.emailReminders,
                                value: state.isEmailEnabled,
                                onChanged: (val) => context.read<SettingsCubit>().toggleEmail(val),
                                textTheme: textTheme,
                                minSide: minSide,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.04),

                        // Кнопка "Save Changes" прибрана, бо зміни миттєві.
                        // Якщо дуже треба, можна залишити її як "заглушку" або
                        // для збереження на сервер (якщо в майбутньому буде API).

                        // --- Кнопка: Вийти ---
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            padding: EdgeInsets.symmetric(vertical: height * 0.015),
                          ),
                          onPressed: () => _showLogOutDialog(context, userEmail, l10n),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.logOut,
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: minSide * 0.05),
                              ),
                              if (userEmail.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  userEmail,
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: minSide * 0.035, color: theme.colorScheme.onError),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required TextTheme textTheme,
    required double minSide,
  }) {
    return Row(
      children: [
        Text(label, style: textTheme.bodyLarge?.copyWith(fontSize: minSide * 0.04)),
        const Spacer(),
        Switch(value: value, onChanged: onChanged),
      ],
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

  void _showLogOutDialog(BuildContext context, String email, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.logOut, style: const TextStyle(fontWeight: FontWeight.w700)),
          content: Text(
            email.isNotEmpty
                ? l10n.areYouSureLogOutFrom(email)
                : l10n.areYouSureLogOut,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                // Закриваємо діалог
                Navigator.pop(dialogContext);

                // Логіка виходу
                context.read<AuthBloc>().add(AuthLogoutRequested());

                // Очищення навігації (повернення до AuthGate)
                Navigator.of(context).popUntil((route) => route.isFirst);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.loggedOutSuccessfully)),
                );
              },
              child: Text(l10n.logOut, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      },
    );
  }
}