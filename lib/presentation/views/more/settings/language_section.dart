import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';
import 'package:nexust/presentation/widgets/common/section_item.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final language = 'Español';
    final primaryColor = Colors.red.shade700;

    return SectionCard(
      title: context.tr('settings.language'),
      children: [
        SectionItem(
          icon: FontAwesomeIcons.lightGlobe,
          title: context.tr('settings.app_language'),
          iconColor: primaryColor,
          trailing: DropdownButton<String>(
            value: language,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: TextStyle(color: context.textPrimary, fontSize: 16),
            underline: Container(height: 2, color: primaryColor),
            onChanged: (String? value) {
              // if (value != null) {
              //   final langCode = value == 'Español' ? 'es' : 'en';
              //   context.read<SettingsCubit>().updateLanguage(
              //     langCode,
              //   );
              //   context.setLocale(Locale(langCode));
              // }
            },
            items:
                ['Español', 'English'].map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
