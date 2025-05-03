import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/data/enums/auth_status.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/widgets/auth/custom_text_field.dart';
import 'package:nexust/presentation/widgets/auth/social_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true; // true = login, false = register
  bool _isResetPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función para validar email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('auth.validation.email_required');
    }
    // Expresión regular simple para validar email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return context.tr('auth.validation.email_invalid');
    }
    return null;
  }

  // Función para validar contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.tr('auth.validation.password_required');
    }
    if (value.length < 6) {
      return context.tr('auth.validation.password_short');
    }
    return null;
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isResetPassword) {
        context.read<AuthCubit>().resetPassword(email);
        return;
      }

      if (_isLogin) {
        context.read<AuthCubit>().signInWithEmailAndPassword(email, password);
      } else {
        context.read<AuthCubit>().createUserWithEmailAndPassword(
          email,
          password,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Navegar a la pantalla principal cuando el usuario está autenticado
          context.goNamed(HomeScreen.routeName);
        } else if (state.status == AuthStatus.error) {
          // Mostrar mensaje de error
          Toast.show(state.errorMessage ?? context.tr('auth.errors.generic'));
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo o imagen
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Image.asset(
                          'assets/images/icon.png',
                          height: 100,
                          width: 100,
                        ),
                      ),

                      // Título
                      Text(
                        _isResetPassword
                            ? context.tr('auth.reset_instructions')
                            : _isLogin
                            ? context.tr('auth.welcome_back')
                            : context.tr('auth.create_account'),
                        style: TextStyle(
                          fontSize: context.scaleText(24),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Subtítulo
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                        child: Text(
                          _isResetPassword
                              ? context.tr('auth.enter_email')
                              : _isLogin
                              ? context.tr('auth.login_to_continue')
                              : context.tr('auth.register_to_start'),
                          style: TextStyle(
                            fontSize: context.scaleText(16),
                            color:
                                isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Formulario
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Campo de correo electrónico
                            CustomTextField(
                              controller: _emailController,
                              label: context.tr('auth.email'),
                              hint: context.tr('auth.email_hint'),
                              prefixIcon: FontAwesomeIcons.lightEnvelope,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: [AutofillHints.email],
                              validator: _validateEmail,
                              autofocus: true,
                            ),
                            const SizedBox(height: 20),

                            // Campo de contraseña (solo mostrar si no es recuperación)
                            if (!_isResetPassword)
                              Column(
                                children: [
                                  CustomTextField(
                                    controller: _passwordController,
                                    label: context.tr('auth.password'),
                                    hint: context.tr('auth.password_hint'),
                                    prefixIcon: FontAwesomeIcons.lightLock,
                                    autofillHints: [
                                      AutofillHints.password,
                                      AutofillHints.newPassword,
                                    ],
                                    isPassword: true,
                                    validator: _validatePassword,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),

                            // Olvidé mi contraseña (solo mostrar en login)
                            if (_isLogin && !_isResetPassword)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isResetPassword = true;
                                    });
                                  },
                                  child: Text(
                                    context.tr('auth.forgot_password'),
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: context.scaleText(14),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 32),

                            // Botón de acción principal
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : () => _submitForm(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child:
                                    isLoading
                                        ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : Text(
                                          _isResetPassword
                                              ? context.tr('auth.reset_button')
                                              : _isLogin
                                              ? context.tr('auth.login_button')
                                              : context.tr(
                                                'auth.register_button',
                                              ),
                                          style: TextStyle(
                                            fontSize: context.scaleText(16),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            ),

                            // Opciones para cambiar de modo
                            if (!_isResetPassword)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _isLogin
                                          ? context.tr('auth.no_account')
                                          : context.tr('auth.have_account'),
                                      style: TextStyle(
                                        fontSize: context.scaleText(14),
                                        color:
                                            isDark
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                        });
                                      },
                                      child: Text(
                                        _isLogin
                                            ? context.tr('auth.signup')
                                            : context.tr('auth.signin'),
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: context.scaleText(14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Opciones para volver desde recuperación de contraseña
                            if (_isResetPassword)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isResetPassword = false;
                                    });
                                  },
                                  child: Text(
                                    context.tr('auth.back_to_login'),
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: context.scaleText(14),
                                    ),
                                  ),
                                ),
                              ),

                            // Separador
                            if (!_isResetPassword && kDebugMode)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color:
                                            isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Text(
                                        context.tr('auth.continue_with'),
                                        style: TextStyle(
                                          fontSize: context.scaleText(14),
                                          color:
                                              isDark
                                                  ? Colors.grey.shade400
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color:
                                            isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Botones sociales
                            if (!_isResetPassword && kDebugMode)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SocialButton(
                                  text: context.tr('auth.google'),
                                  icon: FontAwesomeIcons.google,
                                  iconColor: Colors.red,
                                  onPressed: () {
                                    context
                                        .read<AuthCubit>()
                                        .signInWithGoogle();
                                  },
                                  isLoading: isLoading,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
