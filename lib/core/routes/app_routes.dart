import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/screens/auth/splash_screen.dart';
import 'package:nexust/presentation/screens/more/settings_screen.dart';

class AppRoutes {
  // Variable para controlar si ya se mostró el splash
  static bool _hasShownSplash = false;

  // Variable para controlar si debe mostrar la pantalla de configuraciones
  static bool _shouldShowSettings = false;

  // Método para activar la redirección a configuraciones
  static void activateSettingsRedirect() {
    _shouldShowSettings = true;
  }

  // Método para desactivar la redirección a configuraciones
  static void deactivateSettingsRedirect() {
    _shouldShowSettings = false;
  }

  static RouterConfig<Object>? getGoRoutes(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    List<RouteBase> routes = [
      GoRoute(
        path: "/",
        redirect: (context, state) async {
          return "/${SettingsScreen.routeName}";
          if (!_hasShownSplash) {
            _hasShownSplash = true;
            return "/";
          }

          return null;
        },
        builder: (context, state) => const SplashScreen(),
        routes: [
          GoRoute(
            path: SettingsScreen.routeName,
            name: SettingsScreen.routeName,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: LoginScreen.routeName,
            name: LoginScreen.routeName,
            builder: (context, state) => const LoginScreen(),
          ),
        ],
      ),
    ];

    return GoRouter(
      navigatorKey: navigatorKey,
      routes: routes,
      errorBuilder:
          (context, state) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(child: Text(state.error.toString(), maxLines: 5)),
            ),
          ),
    );
  }

  static T? _getArgument<T>(GoRouterState state, String name) {
    final extra = state.extra;
    if (extra is Map && extra.containsKey(name)) {
      return extra[name] as T;
    }
    return null;
  }
}
