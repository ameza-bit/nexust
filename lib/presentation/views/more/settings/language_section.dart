import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/enums/language.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';
import 'package:nexust/presentation/widgets/common/section_item.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final language = Language.spanish;
    final primaryColor = Colors.red.shade700;

    return SectionCard(
      title: context.tr('settings.language'),
      children: [
        SectionItem(
          icon: FontAwesomeIcons.lightGlobe,
          title: context.tr('settings.app_language'),
          iconColor: primaryColor,
          trailing: DropdownButton<Language>(
            value: language,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: TextStyle(color: context.textPrimary, fontSize: 16),
            underline: Container(height: 2, color: primaryColor),
            onChanged: (Language? value) {
              // if (value != null) {
              //   final langCode = value == 'Español' ? 'es' : 'en';
              //   context.read<SettingsCubit>().updateLanguage(
              //     langCode,
              //   );
              //   context.setLocale(Locale(langCode));
              // }
            },
            items:
                Language.values.map<DropdownMenuItem<Language>>((
                  Language value,
                ) {
                  return DropdownMenuItem<Language>(
                    value: value,
                    child: Text("${value.flag} ${value.name}"),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
