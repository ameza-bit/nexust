import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/color_extensions.dart';

class WebLeftDecorativePanel extends StatelessWidget {
  const WebLeftDecorativePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'web_left_decorative_panel',
      child: Container(
        color: context.selectedColor,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo grande
              Image.asset(
                'assets/images/icon.png',
                height: AppSizes.logoSizeWeb,
                width: AppSizes.logoSizeWeb,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              // Texto descriptivo de la app
              Text(
                context.tr('app.name'),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.tr('app.description'),
                style: TextStyle(
                  fontSize: AppTextSizes.subtitleLarge,
                  color: Colors.white.withAlpha(230),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
