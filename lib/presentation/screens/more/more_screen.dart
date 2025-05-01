import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/screens/collections/proyects_list_screen.dart';
import 'package:nexust/presentation/screens/request/request_history_list_screen.dart';
import 'package:nexust/presentation/screens/settings/enviroments_screen.dart';
import 'package:nexust/presentation/screens/settings/settings_screen.dart';
import 'package:nexust/presentation/widgets/settings/settings_item.dart';
import 'package:nexust/presentation/widgets/settings/settings_section.dart';

class MoreScreen extends StatelessWidget {
  static const String routeName = "more";
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('navigation.more'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de Configuración
                SettingsSection(
                  title: '',
                  children: [
                    // Opción de Cuenta
                    SettingsItem(
                      icon: FontAwesomeIcons.lightUser,
                      title: context.tr('more.account'),
                      iconColor: theme.primaryColor,
                      onTap: () => context.pushNamed(LoginScreen.routeName),
                    ),
                    // Opción de Historial
                    SettingsItem(
                      icon: FontAwesomeIcons.lightClockRotateLeft,
                      title: context.tr('more.historial'),
                      iconColor: theme.primaryColor,
                      onTap:
                          () => context.pushNamed(
                            RequestHistoryListScreen.routeName,
                          ),
                    ),
                    // Opción de Proyectos
                    SettingsItem(
                      icon: FontAwesomeIcons.lightFolder,
                      title: context.tr('more.projects'),
                      iconColor: theme.primaryColor,
                      onTap:
                          () => context.pushNamed(ProyectsListScreen.routeName),
                    ),
                    // Opción de Ambientes
                    SettingsItem(
                      icon: FontAwesomeIcons.lightEarthAmericas,
                      title: context.tr('more.environments'),
                      iconColor: theme.primaryColor,
                      onTap:
                          () => context.pushNamed(EnviromentsScreen.routeName),
                    ),
                    // Opción de Ajustes
                    SettingsItem(
                      icon: FontAwesomeIcons.lightGear,
                      title: context.tr('more.settings'),
                      iconColor: theme.primaryColor,
                      onTap: () {
                        // Activar redirección persistente a configuraciones
                        AppRoutes.activateSettingsRedirect();
                        context.goNamed(SettingsScreen.routeName);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sección de Información
                SettingsSection(
                  title: context.tr('more.app_info'),
                  children: [
                    // Acerca de Nexust
                    SettingsItem(
                      icon: FontAwesomeIcons.lightCircleInfo,
                      title: context.tr('more.about_app'),
                      iconColor: theme.primaryColor,
                      onTap: () => _showAboutDialog(context),
                    ),

                    // Política de Privacidad
                    SettingsItem(
                      icon: FontAwesomeIcons.lightShield,
                      title: context.tr('more.privacy_policy'),
                      iconColor: theme.primaryColor,
                      onTap: () => _showPrivacyPolicyDialog(context),
                    ),

                    // Términos de Servicio
                    SettingsItem(
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
