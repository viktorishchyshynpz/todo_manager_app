import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/core/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final minSide = min(width, height);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // Логотип
                  Flexible(
                    flex: 4,
                    child: SvgPicture.asset(
                      'assets/images/app_icon.svg',
                      width: width * 0.5,
                      height: height * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // Заголовок
                  Text(
                    AppLocalizations.of(context)!.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: minSide * 0.08,
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // Підзаголовок
                  Text(
                    AppLocalizations.of(context)!.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: minSide * 0.04,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Кнопка: Почати
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                              (route) => false,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.getStarted,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: minSide * 0.05,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}