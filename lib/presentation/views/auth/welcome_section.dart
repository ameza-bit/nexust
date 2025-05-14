import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/themes/app_colors.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo o imagen
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Image.asset('assets/images/icon.png', height: 100, width: 100),
        ),

        // Título
        Text(
          context.tr('login.welcome_back'),
          style: TextStyle(
            fontSize: context.scaleText(24),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
          textAlign: TextAlign.center,
        ),

        // Subtítulo
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
          child: Text(
            context.tr('login.login_to_continue'),
            style: TextStyle(
              fontSize: context.scaleText(16),
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
