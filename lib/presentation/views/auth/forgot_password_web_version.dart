import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/views/auth/forgot_password_form_section.dart';
import 'package:nexust/presentation/views/auth/web_left_decorative_panel.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';

class ForgotPasswordWebVersion extends StatelessWidget {
  const ForgotPasswordWebVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Panel izquierdo decorativo (40% del ancho)
        Expanded(flex: AppRatios.webDecoRatio, child: WebLeftDecorativePanel()),

        // Panel derecho con el formulario (60% del ancho)
        Expanded(
          flex: AppRatios.webFormRatio,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.contentPadding),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppBreakpoints.webComponentMaxWidth,
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
                                    () =>
                                        context.goNamed(LoginScreen.routeName),
                                child: Text(
                                  context.tr(
                                    'login.forgot_password.back_to_login',
                                  ),
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
          ),
        ),
      ],
    );
  }
}
