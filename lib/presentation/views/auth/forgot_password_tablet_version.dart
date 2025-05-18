import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/views/auth/forgot_password_form_section.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';

class ForgotPasswordTabletVersion extends StatelessWidget {
  const ForgotPasswordTabletVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.contentPadding,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppBreakpoints.tabletFormMaxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título y subtítulo
                Text(
                  context.tr('login.forgot_password.title'),
                  style: TextStyle(
                    fontSize: context.titleTextSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('login.forgot_password.subtitle'),
                  style: TextStyle(
                    fontSize: context.subtitleTextSize,
                    color: AppColors.textSecondary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Formulario de recuperación
                SectionCard(
                  title: "",
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  children: [
                    ForgotPasswordFormSection(),
                    // Enlace para volver a login
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: TextButton(
                          onPressed:
                              () => context.goNamed(LoginScreen.routeName),
                          child: Text(
                            context.tr('login.forgot_password.back_to_login'),
                            style: TextStyle(
                              color: AppColors.selectedColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
