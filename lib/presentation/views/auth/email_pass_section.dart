import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/themes/app_colors.dart';
import 'package:nexust/presentation/widgets/common/custom_text_field.dart';
import 'package:nexust/presentation/widgets/common/primary_button.dart';

class EmailPassSection extends StatefulWidget {
  const EmailPassSection({super.key});

  @override
  State<EmailPassSection> createState() => _EmailPassSectionState();
}

class _EmailPassSectionState extends State<EmailPassSection> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Función para validar email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.validation.email_required');
    }
    // Expresión regular simple para validar email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return context.tr('login.validation.email_invalid');
    }
    return null;
  }

  // Función para validar contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.validation.password_required');
    }
    if (value.length < 6) {
      return context.tr('login.validation.password_short');
    }
    return null;
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: context.tr('login.email'),
            hint: context.tr('login.email_hint'),
            prefixIcon: FontAwesomeIcons.lightEnvelope,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            autofillHints: const [
              AutofillHints.email,
              AutofillHints.username,
              AutofillHints.newUsername,
            ],
            onEditingComplete: () => _passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            label: context.tr('login.password'),
            hint: context.tr('login.password_hint'),
            prefixIcon: FontAwesomeIcons.lightLock,
            isPassword: true,
            validator: _validatePassword,
            autofillHints: const [
              AutofillHints.password,
              AutofillHints.newPassword,
            ],
            onEditingComplete: () {
              if (_formKey.currentState?.validate() == true) {
                _submitForm(context);
              }
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Implementar funcionalidad
              },
              child: Text(
                context.tr('login.forgot_password'),
                style: TextStyle(
                  color: AppColors.selectedColor(context),
                  fontSize: context.scaleText(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          PrimaryButton(
            text: context.tr('login.login_button'),
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _submitForm(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
