import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/views/auth/web_left_decorative_panel.dart';
import 'package:nexust/presentation/views/more/settings/settings_phone_version.dart';

class AuthSettingsScreen extends StatelessWidget {
  static const String routeName = "auth_settings";
  const AuthSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!context.isWeb) {
      return SettingsPhoneVersion();
    }

    return Scaffold(
      body: Row(
        children: [
          // Panel izquierdo decorativo (40% del ancho)
          Expanded(
            flex: AppRatios.webDecoRatio,
            child: WebLeftDecorativePanel(),
          ),

          // Panel derecho con el formulario (60% del ancho)
          Expanded(flex: AppRatios.webFormRatio, child: SettingsPhoneVersion()),
        ],
      ),
    );
  }
}
