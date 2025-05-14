import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';
import 'package:nexust/presentation/views/auth/social_media_section.dart';
import 'package:nexust/presentation/views/auth/welcome_section.dart';

class LoginPhoneVersion extends StatelessWidget {
  const LoginPhoneVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.contentPadding),
      child: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              WelcomeSection(isLargeScreen: false),
              EmailPassSection(),
              SocialMediaSection(),
            ],
          ),
        ),
      ),
    );
  }
}
