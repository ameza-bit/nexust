import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/widgets/common/custom_text_field.dart';
import 'package:nexust/presentation/widgets/common/primary_button.dart';

class ForgotPasswordFormSection extends StatefulWidget {
  const ForgotPasswordFormSection({super.key});

  @override
  State<ForgotPasswordFormSection> createState() => _ForgotPasswordFormSectionState();
}

class _ForgotPasswordFormSectionState extends State<ForgotPasswordFormSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isSending = false;
  bool _isSuccess = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.forgot_password.validation.email_required');
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return context.tr('login.forgot_password.validation.email_invalid');
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSending = true;
      });
      
      try {
        // TODO: Implementar lógica de recuperación de contraseña con Firebase
        // Simulamos una petición asíncrona
        await Future.delayed(const Duration(seconds: 2));
        
        setState(() {
          _isSuccess = true;
          _isSending = false;
        });
      } catch (e) {
        setState(() {
          _isSending = false;
        });
        // Mostrar error
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return Center(
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.lightCircleCheck,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              context.tr('login.forgot_password.success_message'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.scaleText(18),
              ),
            ),
          ],
        ),
      );
    }
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            label: context.tr('login.forgot_password.email'),
            hint: context.tr('login.forgot_password.email_hint'),
            prefixIcon: FontAwesomeIcons.lightEnvelope,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            autofillHints: const [AutofillHints.email],
            onEditingComplete: _submitForm,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: context.tr('login.forgot_password.send_button'),
            onPressed: _submitForm,
            isLoading: _isSending,
          ),
        ],
      ),
    );
  }
}