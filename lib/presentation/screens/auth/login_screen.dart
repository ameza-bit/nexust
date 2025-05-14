import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/screens/more/settings_screen.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';
import 'package:nexust/presentation/views/auth/social_media_section.dart';
import 'package:nexust/presentation/views/auth/welcome_section.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBackground(context),
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.lightGear),
            onPressed: () => context.pushNamed(SettingsScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  WelcomeSection(),
                  EmailPassSection(),
                  SocialMediaSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
