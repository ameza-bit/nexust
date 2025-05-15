import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';
import 'package:nexust/presentation/views/auth/social_media_section.dart';
import 'package:nexust/presentation/views/auth/web_left_decorative_panel.dart';
import 'package:nexust/presentation/views/auth/welcome_section.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';

class LoginWebVersion extends StatelessWidget {
  const LoginWebVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Panel izquierdo decorativo (40% del ancho)
        Expanded(flex: AppRatios.webDecoRatio, child: WebLeftDecorativePanel()),

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
