import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/presentation/views/more/settings/appearance_section.dart';
import 'package:nexust/presentation/views/more/settings/language_section.dart';
import 'package:nexust/presentation/views/more/settings/security_section.dart';

class SettingsPhoneVersion extends StatelessWidget {
  const SettingsPhoneVersion({super.key});

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
            padding: EdgeInsets.all(
              context.isWeb ? context.contentPadding : 16.0,
            ),
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
