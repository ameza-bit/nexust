import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/constants/app_constants.dart';
import 'package:nexust/core/extensions/color_extensions.dart';
import 'package:nexust/core/extensions/responsive_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/presentation/screens/more/settings_screen.dart';
import 'package:nexust/presentation/views/auth/email_pass_section.dart';
import 'package:nexust/presentation/views/auth/social_media_section.dart';
import 'package:nexust/presentation/views/auth/welcome_section.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.scaffoldBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.lightGear),
            onPressed: () => context.pushNamed(SettingsScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Builder(
          builder: (context) {
            // Diseño para web (pantallas grandes)
            if (context.isWeb) {
              return Row(
                children: [
                  // Panel izquierdo decorativo (40% del ancho)
                  Expanded(
                    flex: AppRatios.webDecoRatio,
                    child: Container(
                      color: context.selectedColor,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxxl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo grande
                            Image.asset(
                              'assets/images/icon.png',
                              height: AppSizes.logoSizeWeb,
                              width: AppSizes.logoSizeWeb,
                            ),
                            const SizedBox(height: AppSpacing.xxxl),
                            // Texto descriptivo de la app
                            const Text(
                              'Nexust',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'El punto central donde convergen todas tus APIs',
                              style: TextStyle(
                                fontSize: AppTextSizes.subtitleLarge,
                                color: Colors.white.withAlpha(230),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Panel derecho con el formulario (60% del ancho)
                  Expanded(
                    flex: AppRatios.webFormRatio,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.contentPadding,
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: AppBreakpoints.webComponentMaxWidth,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                WelcomeSection(isLargeScreen: true),
                                EmailPassSection(),
                                SocialMediaSection(),
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
            // Diseño para tablet
            else if (context.isTablet) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.contentPadding,
                  vertical: AppSpacing.lg,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppBreakpoints.tabletFormMaxWidth,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const WelcomeSection(isLargeScreen: true),
                          const SizedBox(height: AppSpacing.lg),
                          Card(
                            elevation: AppSizes.cardElevation,
                            color: context.cardBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.card,
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(AppSpacing.xxl),
                              child: Column(
                                children: [
                                  EmailPassSection(),
                                  SocialMediaSection(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            // Diseño original para móvil
            else {
              return Padding(
                padding: EdgeInsets.all(context.contentPadding),
                child: const Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        WelcomeSection(isLargeScreen: false),
                        EmailPassSection(),
                        SocialMediaSection(),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
