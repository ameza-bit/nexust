import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/utils/toast.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/widgets/settings/settings_item.dart';
import 'package:nexust/presentation/widgets/settings/settings_section.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = "user_profile";
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          // Redirigir al login cuando se cierra sesión
          context.goNamed(LoginScreen.routeName);
        }
      },
      builder: (context, state) {
        // Verificar si hay un usuario autenticado
        final User? user = state.user;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.tr('auth.profile.title'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: theme.appBarTheme.backgroundColor,
            foregroundColor: theme.appBarTheme.foregroundColor,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Información del usuario
                    _buildUserInfo(context, user, theme, isDark),
                    const SizedBox(height: 24),

                    // Sección de cuenta
                    SettingsSection(
                      title: context.tr('auth.profile.account'),
                      children: [
                        SettingsItem(
                          icon: FontAwesomeIcons.lightKey,
                          title: context.tr('auth.profile.change_password'),
                          iconColor: theme.primaryColor,
                          onTap: () {
                            // Implementar cambio de contraseña
                            _showResetPasswordDialog(context);
                          },
                        ),
                        SettingsItem(
                          icon: FontAwesomeIcons.lightUser,
                          title: context.tr('auth.profile.edit_profile'),
                          iconColor: theme.primaryColor,
                          onTap: () {
                            // Implementar edición de perfil
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sección de seguridad
                    SettingsSection(
                      title: context.tr('auth.profile.security'),
                      children: [
                        SettingsItem(
                          icon: FontAwesomeIcons.lightRightFromBracket,
                          title: context.tr('auth.profile.sign_out'),
                          iconColor: Colors.red,
                          onTap: () {
                            _showSignOutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(
    BuildContext context,
    User? user,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar del usuario
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.primaryColor.withAlpha(26),
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child:
                user?.photoURL == null
                    ? Text(
                      _getInitials(user?.displayName ?? user?.email ?? ''),
                      style: TextStyle(
                        fontSize: context.scaleText(32),
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    )
                    : null,
          ),
          const SizedBox(height: 16),

          // Nombre del usuario
          Text(
            user?.displayName ?? context.tr('auth.profile.user'),
            style: TextStyle(
              fontSize: context.scaleText(20),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // Correo del usuario
          Text(
            user?.email ?? '',
            style: TextStyle(
              fontSize: context.scaleText(14),
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          // Insignia de verificación
          if (user != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    user.emailVerified
                        ? Colors.green.withAlpha(26)
                        : Colors.orange.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: user.emailVerified ? Colors.green : Colors.orange,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    user.emailVerified
                        ? FontAwesomeIcons.lightCircleCheck
                        : FontAwesomeIcons.lightCircleExclamation,
                    size: context.scaleIcon(14),
                    color: user.emailVerified ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.emailVerified
                        ? context.tr('auth.profile.verified')
                        : context.tr('auth.profile.not_verified'),
                    style: TextStyle(
                      fontSize: context.scaleText(12),
                      fontWeight: FontWeight.w500,
                      color: user.emailVerified ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

          // Botón para verificar correo si no está verificado
          if (user != null && !user.emailVerified)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton.icon(
                onPressed: () {
                  _sendVerificationEmail(context, user);
                },
                icon: Icon(
                  FontAwesomeIcons.lightEnvelopeCircleCheck,
                  size: context.scaleIcon(16),
                ),
                label: Text(context.tr('auth.profile.send_verification')),
                style: TextButton.styleFrom(
                  foregroundColor: theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    if (name.contains('@')) {
      // Si es un correo, tomar la primera letra antes del @
      return name.split('@')[0][0].toUpperCase();
    }

    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('auth.profile.sign_out')),
            content: Text(context.tr('auth.profile.sign_out_confirm')),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(context.tr('common.cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.tr('auth.profile.sign_out')),
              ),
            ],
          ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Cambiar contraseña'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Se enviará un correo con instrucciones para cambiar tu contraseña.',
                    style: TextStyle(fontSize: context.scaleText(14)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo electrónico';
                      }
                      // Validar formato de correo
                      final emailRegExp = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Por favor ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context);
                    context.read<AuthCubit>().resetPassword(
                      emailController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Se ha enviado un correo para restablecer tu contraseña',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text('Enviar'),
              ),
            ],
          ),
    );
  }

  void _sendVerificationEmail(BuildContext context, User user) async {
    try {
      await user.sendEmailVerification();

      String message = 'auth.profile.verification_sent'.tr(
        namedArgs: {'email': user.email ?? ''},
      );

      if (context.mounted) {
        message = context.tr(
          'auth.profile.verification_sent',
          namedArgs: {'email': user.email ?? ''},
        );
      }

      Toast.show(message, backgroundColor: Colors.green);
    } catch (e) {
      String message = 'auth.profile.verification_error'.tr(
        namedArgs: {'error': e.toString()},
      );
      if (context.mounted) {
        message = context.tr(
          'auth.profile.verification_error',
          namedArgs: {'error': e.toString()},
        );
      }

      Toast.show(message, backgroundColor: Colors.red);
    }
  }
}
