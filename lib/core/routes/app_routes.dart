import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/core/utils/page_transition.dart';
import 'package:nexust/presentation/screens/auth/forgot_password_screen.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/screens/auth/register_screen.dart';
import 'package:nexust/presentation/screens/auth/splash_screen.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/screens/home/redirect_screen.dart';
import 'package:nexust/presentation/screens/home/tabs_screen.dart'
    show TabsScreen;
import 'package:nexust/presentation/screens/more/settings_screen.dart';

class AppRoutes {
  // Variable para controlar si ya se mostró el splash
  static bool _hasShownSplash = false;

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
            routes: [
              GoRoute(
                path: RegisterScreen.routeName,
                name: RegisterScreen.routeName,
                builder: (context, state) => const RegisterScreen(),
              ),
              GoRoute(
                path: ForgotPasswordScreen.routeName,
                name: ForgotPasswordScreen.routeName,
                builder: (context, state) => const ForgotPasswordScreen(),
              ),
            ],
          ),
          GoRoute(
            path: HomeScreen.routeName,
            name: HomeScreen.routeName,
            builder: (context, state) {
              int? mainTabIndex = int.tryParse(
                _getParameter(state, "mainTabIndex"),
              );
              return TabsScreen(initialIndex: mainTabIndex);
            },
            routes: [
              GoRoute(
                path: SettingsScreen.routeName,
                name: SettingsScreen.routeName,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
          GoRoute(
            name: RedirectScreen.routeName,
            path: RedirectScreen.routeName,
            pageBuilder:
                (context, state) =>
                    PageTransition(
                      context: context,
                      state: state,
                      page: RedirectScreen(
                        _getParameter(state, "redirect_route"),
                        int.tryParse(_getParameter(state, "wait_time")) ?? 0,
                      ),
                      duration: const Duration(milliseconds: 300),
                    ).fadeTransition(),
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
        final FirebaseAuth auth = FirebaseAuth.instance;
        final isSplashRoute = state.matchedLocation == "/";
        final isAuthenticated = auth.currentUser != null;

        if (_hasShownSplash) {
          if (isSplashRoute) {
            return isAuthenticated
                ? "/${HomeScreen.routeName}"
                : "/${LoginScreen.routeName}";
          }
        } else if (!isSplashRoute) {
          return "/?redirected=${state.uri.path}";
        }

        return null;
      },
    );
  }

  static String _getParameter(GoRouterState state, String name) {
    final uri = state.uri.queryParameters;
    if (uri.containsKey(name)) {
      return uri[name] ?? "";
    } else {
      return "";
    }
  }
}
