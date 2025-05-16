import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/screens/auth/splash_screen.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
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
        builder: (context, state) {
          _hasShownSplash = true;
          return const SplashScreen();
        },
        routes: [
          GoRoute(
            path: LoginScreen.routeName,
            name: LoginScreen.routeName,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: HomeScreen.routeName,
            name: HomeScreen.routeName,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: SettingsScreen.routeName,
                name: SettingsScreen.routeName,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
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
      redirect: (context, state) {
        if (_hasShownSplash && state.matchedLocation == "/") {
          if (FirebaseAuth.instance.currentUser != null) {
            return "/${HomeScreen.routeName}";
          }
          return "/${LoginScreen.routeName}";
        } else if (!_hasShownSplash && state.matchedLocation != "/") {
          return "/?redirected=${state.uri.path}";
        }

        return null;
      },
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
