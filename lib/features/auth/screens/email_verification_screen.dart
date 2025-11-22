import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';
import '../../../core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthRepository _authRepository = AuthRepository.instance;

  bool _isLoading = false;
  bool _isResending = false;
  bool _isDeleting = false; // Щоб уникнути подвійного виклику видалення

  int _secondsRemaining = 60;
  Timer? _verificationTimer;

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

  // --- ДОПОМІЖНІ МЕТОДИ (DRY) ---

  void _navigateToWelcome() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (_) => false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // --- ЛОГІКА ---

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
          // Час вийшов - агресивне видалення
          _deleteUnverifiedAccount(reason: 'timeout');
        }
      });
    });
  }

  /// Агресивне видалення акаунту
  /// [reason] - 'timeout' (час вийшов) або 'exit' (натиснув кнопку виходу)
  Future<void> _deleteUnverifiedAccount({String reason = 'exit'}) async {
    if (_isDeleting) return;
    _isDeleting = true;

    // Зупиняємо таймер, щоб він не тригерив нічого паралельно
    _verificationTimer?.cancel();

    final l10n = AppLocalizations.of(context)!;

    try {
      final user = _authRepository.currentUser;

      // Якщо користувача вже немає (вилогінився десь інде), просто йдемо на Welcome
      if (user == null) {
        _navigateToWelcome();
        return;
      }

      // Оновлюємо, щоб переконатися, що він все ще не верифікований
      await user.reload();
      final reloadedUser = FirebaseAuth.instance.currentUser;

      // Видаляємо ТІЛЬКИ якщо пошта досі не підтверджена
      if (reloadedUser != null && !reloadedUser.emailVerified) {
        await reloadedUser.delete();

        // Показуємо повідомлення залежно від причини
        if (reason == 'timeout') {
          _showSnackBar(l10n.emailVerificationExpiredMessage);
        }
      }

      // Успішно видалили або він був вже верифікований (але ми все одно виходимо)
      _navigateToWelcome();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Якщо видалення вимагає повторного входу - просто виходимо
        await _authRepository.signOut();
        _showSnackBar(l10n.deleteRequiresRecentLogin);
        _navigateToWelcome();
      } else {
        // Інші помилки
        _showSnackBar(l10n.errorWithDetails(e.message ?? 'Unknown error'), isError: true);
        // Все одно викидаємо на Welcome, щоб не застряг на екрані
        _navigateToWelcome();
      }
    } catch (e) {
      _showSnackBar(l10n.errorWithDetails(e.toString()), isError: true);
      _navigateToWelcome();
    } finally {
      if (mounted) {
        _isDeleting = false;
      }
    }
  }

  Future<void> _checkEmailVerified() async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await _authRepository.currentUser?.reload();
      final user = _authRepository.currentUser;

      if (user?.emailVerified == true) {
        _verificationTimer?.cancel();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
        }
      } else {
        _showSnackBar(l10n.emailNotVerifiedMessage);
      }
    } catch (e) {
      _showSnackBar(l10n.errorWithDetails(e.toString()), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isResending = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await _authRepository.sendVerificationEmail();

      setState(() {
        _secondsRemaining = 60;
      });
      // --------------------------------------------------

      _showSnackBar(l10n.resendVerificationSuccess);
    } catch (e) {
      _showSnackBar(l10n.errorWithDetails(e.toString()), isError: true);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // Оголошуємо l10n один раз
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emailVerificationAppBar),
        actions: [
          // Кнопка примусового виходу з видаленням
          IconButton(
            icon: Icon(Icons.exit_to_app, color: theme.iconTheme.color),
            onPressed: () => _deleteUnverifiedAccount(reason: 'exit'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.emailVerificationHeader,
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.emailVerificationSentTo(_authRepository.currentUser?.email ?? ''),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    // Таймер
                    Column(
                      children: [
                        Text(
                          l10n.emailVerificationTimeLabel,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(_secondsRemaining),
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _secondsRemaining < 10 ? theme.colorScheme.error : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.emailVerificationTimeExpiredNote,
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    if (_isLoading)
                      CircularProgressIndicator(color: theme.colorScheme.primary)
                    else
                      ElevatedButton(
                        onPressed: _checkEmailVerified,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.emailVerifiedButton,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: _isResending ? null : _resendVerificationEmail,
                      child: _isResending
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      )
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
    );
  }
}