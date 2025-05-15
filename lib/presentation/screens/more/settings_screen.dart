import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/presentation/views/more/settings/appearance_section.dart';
import 'package:nexust/presentation/views/more/settings/language_section.dart';
import 'package:nexust/presentation/views/more/settings/security_section.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr("settings.title"),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                // Tema
                AppearanceSection(),
                // Idioma
                LanguageSection(),
                // Seguridad
                SecuritySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
