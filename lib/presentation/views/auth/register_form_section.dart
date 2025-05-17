import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/widgets/common/custom_text_field.dart';
import 'package:nexust/presentation/widgets/common/primary_button.dart';

class RegisterFormSection extends StatefulWidget {
  const RegisterFormSection({super.key});

  @override
  State<RegisterFormSection> createState() => _RegisterFormSectionState();
}

class _RegisterFormSectionState extends State<RegisterFormSection> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.register.validation.name_required');
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.register.validation.email_required');
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return context.tr('login.register.validation.email_invalid');
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.register.validation.password_required');
    }
    if (value.length < 6) {
      return context.tr('login.register.validation.password_short');
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('login.register.validation.password_required');
    }
    if (value != _passwordController.text) {
      return context.tr('login.register.validation.password_mismatch');
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      context.read<AuthCubit>().registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Navegar a la pantalla principal cuando el registro es exitoso
          context.goNamed(HomeScreen.routeName);
        } else if (state.status == AuthStatus.error) {
          // Mostrar mensaje de error
          Toast.show(
            state.errorMessage ?? 'Error al registrar usuario',
            backgroundColor: Colors.red,
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              label: context.tr('login.register.name'),
              hint: context.tr('login.register.name_hint'),
              prefixIcon: FontAwesomeIcons.lightUser,
              keyboardType: TextInputType.name,
              validator: _validateName,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              onEditingComplete: () => _emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              label: context.tr('login.register.email'),
              hint: context.tr('login.register.email_hint'),
              prefixIcon: FontAwesomeIcons.lightEnvelope,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username,
              ],
              onEditingComplete: () => _passwordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              label: context.tr('login.register.password'),
              hint: context.tr('login.register.password_hint'),
              prefixIcon: FontAwesomeIcons.lightLock,
              isPassword: true,
              validator: _validatePassword,
              autofillHints: const [AutofillHints.newPassword],
              onEditingComplete: () => _confirmPasswordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              label: context.tr('login.register.confirm_password'),
              hint: context.tr('login.register.confirm_password_hint'),
              prefixIcon: FontAwesomeIcons.lightLock,
              isPassword: true,
              validator: _validateConfirmPassword,
              autofillHints: const [AutofillHints.newPassword],
              onEditingComplete: _submitForm,
            ),
            const SizedBox(height: 32),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return PrimaryButton(
                  text: context.tr('login.register.register_button'),
                  onPressed: _submitForm,
                  isLoading: state.status == AuthStatus.loading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
