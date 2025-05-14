import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart'; // O theme_extensions.dart
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/themes/app_colors.dart';

class WelcomeSection extends StatelessWidget {
  final bool isLargeScreen;

  const WelcomeSection({super.key, this.isLargeScreen = false});

  @override
  Widget build(BuildContext context) {
    // Podemos usar isLargeScreen desde el parámetro o determinar dinámicamente
    // En este caso, usamos la que se pasa como parámetro para mantener la compatibilidad
    final logoSize =
        isLargeScreen ? AppSizes.logoSizeTablet : AppSizes.logoSizeMobile;

    final verticalSpacing =
        isLargeScreen ? context.sectionSpacing : context.sectionSpacing;

    return Column(
      children: [
        // Logo o imagen
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalSpacing),
          child: Image.asset(
            'assets/images/icon.png',
            height: logoSize,
            width: logoSize,
          ),
        ),

        // Título
        Text(
          context.tr('login.welcome_back'),
          style: TextStyle(
            fontSize: context.scaleText(context.titleTextSize),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
          textAlign: TextAlign.center,
        ),

        // Subtítulo
        Padding(
          padding: EdgeInsets.only(top: AppSpacing.xs, bottom: verticalSpacing),
          child: Text(
            context.tr('login.login_to_continue'),
            style: TextStyle(
              fontSize: context.scaleText(context.subtitleTextSize),
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
