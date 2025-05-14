import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';

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
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                // Logo o imagen
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Image.asset(
                    'assets/images/icon.png',
                    height: 100,
                    width: 100,
                  ),
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

                EmailPassSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
