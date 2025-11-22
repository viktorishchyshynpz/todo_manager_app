import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/analytics_service.dart';
import '../data/repositories/auth_repository.dart';
import '../../../core/validators/auth_validator.dart';
import '../../../core/utils/auth_exception_handler.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  final AnalyticsService _analytics = AnalyticsService.instance;
  final AuthRepository _authRepository = AuthRepository.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Реєструємо користувача
      await _authRepository.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Відправляємо лист підтвердження
      await _authRepository.sendVerificationEmail();

      await _analytics.logSignUp('email_password');

      if (mounted) {
        // Показуємо повідомлення, що треба перевірити пошту
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Акаунт створено! Перевірте пошту для підтвердження.'),
            duration: Duration(seconds: 4),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // Замість переходу на головну - переходимо на екран підтвердження
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.emailVerification, // Використовуємо правильний маршрут
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        // Перетворюємо код помилки на перекладений текст
        final errorMessage = AuthExceptionHandler.generateErrorMessage(context, e.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final minSide = min(width, height);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: max(MediaQuery.of(context).viewInsets.bottom, height * 0.03),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: height * 0.08),
                          SvgPicture.asset(
                            'assets/images/app_icon.svg',
                            width: width * 0.35,
                            height: height * 0.15,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: height * 0.03),
                          Text(
                            AppLocalizations.of(context)!.appName,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: minSide * 0.08,
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          Text(
                            AppLocalizations.of(context)!.createYourAccount,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: minSide * 0.045,
                            ),
                          ),
                          SizedBox(height: height * 0.05),

                          _CustomTextField(
                            controller: _emailController,
                            hintText: AppLocalizations.of(context)!.email,
                            keyboardType: TextInputType.emailAddress,
                            minSide: minSide,
                            validator: (value) => AuthValidator.validateEmail(context, value),
                          ),
                          SizedBox(height: height * 0.02),

                          _CustomTextField(
                            controller: _passwordController,
                            hintText: AppLocalizations.of(context)!.password,
                            isPassword: true,
                            minSide: minSide,
                            validator: (value) => AuthValidator.validatePassword(context, value),
                          ),
                          SizedBox(height: height * 0.02),

                          _CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: AppLocalizations.of(context)!.confirmPassword,
                            isPassword: true,
                            minSide: minSide,
                            validator: (value) => AuthValidator.validateConfirmPassword(
                              context,
                              value,
                              _passwordController.text,
                            ),
                          ),
                          SizedBox(height: height * 0.04),

                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.register,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: minSide * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.alreadyHaveAccount,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: minSide * 0.038,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToLogin,
                                child: Text(
                                  AppLocalizations.of(context)!.logIn,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: minSide * 0.038,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.03),
                        ],
                      ),
                    ),
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

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.minSide,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final double minSide;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: minSide * 0.04,
      ),
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}