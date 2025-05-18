import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';
import 'package:nexust/presentation/views/auth/social_media_section.dart';
import 'package:nexust/presentation/views/auth/welcome_section.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';

class LoginTabletVersion extends StatelessWidget {
  const LoginTabletVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.contentPadding,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppBreakpoints.tabletFormMaxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WelcomeSection(isLargeScreen: true),
                const SizedBox(height: AppSpacing.lg),
                SectionCard(
                  title: "",
                  showDivider: false,
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  children: [EmailPassSection(), SocialMediaSection()],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
