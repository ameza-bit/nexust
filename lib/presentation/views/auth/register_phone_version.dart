import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/views/auth/register_form_section.dart';

class RegisterPhoneVersion extends StatelessWidget {
  const RegisterPhoneVersion({super.key});

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
                context.tr('login.register.title'),
                style: TextStyle(
                  fontSize: context.titleTextSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('login.register.subtitle'),
                style: TextStyle(
                  fontSize: context.subtitleTextSize,
                  color: AppColors.textSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Formulario de registro
              const RegisterFormSection(),

              // Enlace para ir a login
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('login.register.already_have_account'),
                    style: TextStyle(color: AppColors.textSecondary(context)),
                  ),
                  TextButton(
                    onPressed: () => context.goNamed(LoginScreen.routeName),
                    child: Text(
                      context.tr('login.register.login'),
                      style: TextStyle(
                        color: AppColors.selectedColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
