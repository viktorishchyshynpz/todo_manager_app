import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/bloc/auth_bloc.dart';
import '../logic/bloc/auth_event.dart';
import '../logic/bloc/auth_state.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  int _secondsRemaining = 60;
  Timer? _verificationTimer;
  bool _isResending = false; // Для локального UI ефекту (щоб не блокувати весь екран блоком)

  @override
  void initState() {
    super.initState();
    _startVerificationTimer();
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  void _startVerificationTimer() {
    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          // Час вийшов - викликаємо подію видалення в Блоці
          context.read<AuthBloc>().add(AuthDeleteAccountRequested());
        }
      });
    });
  }

  void _onCheckPressed() {
    context.read<AuthBloc>().add(AuthCheckVerificationStatus());
  }

  void _onResendPressed() {
    setState(() => _isResending = true);
    context.read<AuthBloc>().add(AuthResendVerificationEmail());
    // Скидаємо таймер локально
    setState(() {
      _secondsRemaining = 60;
      _isResending = false;
    });
    // Перезапускаємо таймер, якщо він зупинився
    if (!(_verificationTimer?.isActive ?? false)) {
      _startVerificationTimer();
    }
  }

  void _onExitPressed() {
    context.read<AuthBloc>().add(AuthDeleteAccountRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Отримуємо email з поточного стану
    final email = context.select((AuthBloc bloc) => bloc.state.user?.email ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emailVerificationAppBar),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: theme.iconTheme.color),
            onPressed: _onExitPressed,
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Успішно підтверджено
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (_) => false);
          } else if (state.status == AuthStatus.unauthenticated) {
            // Акаунт видалено або вийшов
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.welcome, (_) => false);
          } else if (state.errorMessage != null) {
            // Обробка помилок
            if (state.errorMessage == 'email-not-verified') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.emailNotVerifiedMessage)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          } else if (state.infoMessage != null) {
            if (state.infoMessage == 'verification-email-sent') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.resendVerificationSuccess)),
              );
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email_outlined, size: 80, color: theme.colorScheme.primary),
                      const SizedBox(height: 24),
                      Text(l10n.emailVerificationHeader, style: textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(l10n.emailVerificationSentTo(email), textAlign: TextAlign.center, style: textTheme.bodyLarge),
                      const SizedBox(height: 24),

                      // Таймер
                      Column(
                        children: [
                          Text(l10n.emailVerificationTimeLabel, style: textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Text(
                            '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _secondsRemaining < 10 ? theme.colorScheme.error : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.emailVerificationTimeExpiredNote, textAlign: TextAlign.center, style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                        ],
                      ),

                      const SizedBox(height: 32),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state.status == AuthStatus.loading) {
                            return CircularProgressIndicator(color: theme.colorScheme.primary);
                          }
                          return ElevatedButton(
                            onPressed: _onCheckPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(l10n.emailVerifiedButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: _isResending ? null : _onResendPressed,
                        child: _isResending
                            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary))
                            : Text(l10n.resendVerificationButton),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}