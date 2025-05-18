import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/views/auth/register_phone_version.dart';
import 'package:nexust/presentation/views/auth/register_tablet_version.dart';
import 'package:nexust/presentation/views/auth/register_web_version.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "register";
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.lightArrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Builder(
          builder:
              (context) =>
                  context.isWeb
                      ? const RegisterWebVersion()
                      : context.isTablet
                      ? const RegisterTabletVersion()
                      : const RegisterPhoneVersion(),
        ),
      ),
    );
  }
}
