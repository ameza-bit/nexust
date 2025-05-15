import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/widgets/common/secundary_button.dart';

class SocialMediaSection extends StatelessWidget {
  const SocialMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Separador
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            children: [
              Expanded(child: Divider(color: AppColors.border(context))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  context.tr('login.continue_with'),
                  style: TextStyle(
                    fontSize: context.scaleText(14),
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.border(context))),
            ],
          ),
        ),

        // Botones sociales
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SecondaryButton(
            text: context.tr('login.google'),
            icon: FontAwesomeIcons.google,
            iconColor: Colors.red,
            onPressed: () {
              // TODO: Implementar autenticación con Google
            },
          ),
        ),
      ],
    );
  }
}
