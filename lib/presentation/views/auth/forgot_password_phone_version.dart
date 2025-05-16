import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/views/auth/forgot_password_form_section.dart';

class ForgotPasswordPhoneVersion extends StatelessWidget {
  const ForgotPasswordPhoneVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.contentPadding),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
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
              const SizedBox(height: 32),

              // Formulario de recuperación
              const ForgotPasswordFormSection(),

              // Enlace para volver a login
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => context.goNamed(LoginScreen.routeName),
                  child: Text(
                    context.tr('login.forgot_password.back_to_login'),
                    style: TextStyle(
                      color: AppColors.selectedColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
