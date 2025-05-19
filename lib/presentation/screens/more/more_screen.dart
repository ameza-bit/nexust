import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/routes/menu_route.dart';
import 'package:nexust/domain/entities/user_entity.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';
import 'package:nexust/presentation/widgets/common/section_card.dart';
import 'package:nexust/presentation/widgets/common/section_item.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.contentPaddingMobile),
            child: Column(
              children: [
                Image.asset('assets/images/icon.png', height: 100),
                const SizedBox(height: 16),

                SectionCard(
                  title: '',
                  children: [
                    // Perfil de usuario o iniciar sesión
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final UserEntity? user = state.user;
                        final bool isAuthenticated = user != null;

                        return SectionItem(
                          icon:
                              isAuthenticated
                                  ? FontAwesomeIcons.lightUser
                                  : FontAwesomeIcons.lightRightToBracket,
                          title:
                              isAuthenticated
                                  ? user.name ?? user.email ?? 'Mi Perfil'
                                  : context.tr('more.account'),
                          subtitle:
                              isAuthenticated
                                  ? context.tr('more.profile.view_edit_profile')
                                  : context.tr('more.profile.login_to_sync'),
                          iconColor: theme.primaryColor,
                          // onTap: () {
                          //   if (isAuthenticated) {
                          //     context.pushNamed(UserProfileScreen.routeName);
                          //   } else {
                          //     context.pushNamed(LoginScreen.routeName);
                          //   }
                          // },
                        );
                      },
                    ),

                    ...MenuRoute(context).menuItems.map(
                      (item) => SectionItem(
                        icon: item.icon,
                        title: item.label,
                        iconColor: theme.primaryColor,
                        onTap: () => context.push(item.route),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sección de Información
                SectionCard(
                  title: context.tr('more.app_info'),
                  children: [
                    // Acerca de Nexust
                    SectionItem(
                      icon: FontAwesomeIcons.lightCircleInfo,
                      title: context.tr('more.about_app'),
                      iconColor: theme.primaryColor,
                      onTap: () => _showAboutDialog(context),
                    ),

                    // Política de Privacidad
                    SectionItem(
                      icon: FontAwesomeIcons.lightShield,
                      title: context.tr('more.privacy_policy'),
                      iconColor: theme.primaryColor,
                      onTap: () => _showPrivacyPolicyDialog(context),
                    ),

                    // Términos de Servicio
                    SectionItem(
                      icon: FontAwesomeIcons.lightFileContract,
                      title: context.tr('more.terms_of_service'),
                      iconColor: theme.primaryColor,
                      onTap: () => _showTermsOfServiceDialog(context),
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

void _showAboutDialog(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(context.tr('more.about_app')),
          backgroundColor: isDark ? theme.cardColor : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nexust es un cliente REST avanzado multiplataforma desarrollado con Flutter que transforma la manera en que interactúas con APIs.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                '© 2025 Axolotl Software',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.tr('common.close'),
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        ),
  );
}

void _showPrivacyPolicyDialog(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(context.tr('more.privacy_policy')),
          backgroundColor: isDark ? theme.cardColor : Colors.white,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Política de Privacidad de Nexust',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Última actualización: 26 de abril de 2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Esta Política de Privacidad describe cómo se recopila, utiliza y comparte su información cuando utiliza nuestra aplicación Nexust.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  '• Información que recopilamos: URLs de API, datos de solicitudes y respuestas, y configuraciones de usuario.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Uso de la información: Para proporcionar, mantener y mejorar nuestros servicios.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Almacenamiento: Su información se almacena localmente en su dispositivo y opcionalmente en la nube con su consentimiento.',
                  style: TextStyle(fontSize: 14),
                ),
                // Aquí iría el resto del contenido de la política de privacidad
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.tr('common.close'),
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        ),
  );
}

void _showTermsOfServiceDialog(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(context.tr('more.terms_of_service')),
          backgroundColor: isDark ? theme.cardColor : Colors.white,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Términos de Servicio de Nexust',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Última actualización: 26 de abril de 2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Al utilizar nuestra aplicación Nexust, usted acepta estos términos. Por favor, léalos cuidadosamente.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  '• Uso de la aplicación: La aplicación Nexust se proporciona "tal cual" y "según disponibilidad".',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Propiedad intelectual: Nexust y su contenido original son propiedad de Axolotl Software.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Responsabilidad del usuario: Usted es responsable de todas las actividades que ocurran a través de su cuenta.',
                  style: TextStyle(fontSize: 14),
                ),
                // Aquí iría el resto del contenido de los términos de servicio
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                context.tr('common.close'),
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        ),
  );
}
