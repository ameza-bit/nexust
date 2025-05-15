import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';
import 'package:nexust/presentation/views/auth/social_media_section.dart';
import 'package:nexust/presentation/views/auth/welcome_section.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';

class LoginWebVersion extends StatelessWidget {
  const LoginWebVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Panel izquierdo decorativo (40% del ancho)
        Expanded(
          flex: AppRatios.webDecoRatio,
          child: Container(
            color: context.selectedColor,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo grande
                  Image.asset(
                    'assets/images/icon.png',
                    height: AppSizes.logoSizeWeb,
                    width: AppSizes.logoSizeWeb,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Texto descriptivo de la app
                  Text(
                    context.tr('app.name'),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.tr('app.description'),
                    style: TextStyle(
                      fontSize: AppTextSizes.subtitleLarge,
                      color: Colors.white.withAlpha(230),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Panel derecho con el formulario (60% del ancho)
        Expanded(
          flex: AppRatios.webFormRatio,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.contentPadding),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppBreakpoints.webComponentMaxWidth,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WelcomeSection(isLargeScreen: true),
                      SectionCard(
                        title: "",
                        padding: EdgeInsets.all(AppSpacing.xxl),
                        children: [EmailPassSection(), SocialMediaSection()],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
