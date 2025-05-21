import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/screens/auth/auth_settings_screen.dart';
import 'package:nexust/presentation/views/auth/login_phone_version.dart';
import 'package:nexust/presentation/views/auth/login_tablet_version.dart';
import 'package:nexust/presentation/views/auth/login_web_version.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.lightGear),
              onPressed: () => context.pushNamed(AuthSettingsScreen.routeName),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Builder(
            builder:
                (context) =>
                    context.isWeb
                        ? const LoginWebVersion()
                        : context.isTablet
                        ? const LoginTabletVersion()
                        : const LoginPhoneVersion(),
          ),
        ),
      ),
    );
  }
}
