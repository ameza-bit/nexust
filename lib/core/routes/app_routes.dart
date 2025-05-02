import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/presentation/screens/auth/edit_profile_screen.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/screens/auth/splash_screen.dart';
import 'package:nexust/presentation/screens/auth/user_profile_screen.dart';
import 'package:nexust/presentation/screens/collections/proyects_list_screen.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/screens/home/tabs_screen.dart';
import 'package:nexust/presentation/screens/request/request_history_list_screen.dart';
import 'package:nexust/presentation/screens/request/request_screen.dart';
import 'package:nexust/presentation/screens/settings/enviroments_screen.dart';
import 'package:nexust/presentation/screens/settings/settings_screen.dart';

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
          // Si ya se mostró el splash, redirigir directamente al home
          if (_hasShownSplash) {
            return "/${HomeScreen.routeName}";
          }
          // Marcar que ya se mostró el splash
          _hasShownSplash = true;
          return null; // No redirigir, mostrar el splash
        },
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: "/${LoginScreen.routeName}",
        builder: (context, state) => const LoginScreen(),
        redirect: (context, state) {
          // Si el usuario ya está autenticado, redirigir al home
          if (FirebaseAuth.instance.currentUser != null) {
            return "/${HomeScreen.routeName}";
          }
          return null;
        },
      ),
      GoRoute(
        name: HomeScreen.routeName,
        path: "/${HomeScreen.routeName}",
        redirect: (context, state) {
          // Verificar si el usuario está autenticado
          if (FirebaseAuth.instance.currentUser == null) {
            return "/${LoginScreen.routeName}";
          }

          if (_shouldShowSettings) {
            return "/${HomeScreen.routeName}/${SettingsScreen.routeName}?initialIndex=3";
          }
          return null;
        },
        builder:
            (context, state) => TabsScreen(
              initialIndex: int.tryParse(
                state.uri.queryParameters["initialIndex"] ?? "",
              ),
            ),
        routes: [
          GoRoute(
            name: UserProfileScreen.routeName,
            path: UserProfileScreen.routeName,
            builder: (context, state) => const UserProfileScreen(),
            routes: [
              GoRoute(
                name: EditProfileScreen.routeName,
                path: EditProfileScreen.routeName,
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            name: RequestHistoryListScreen.routeName,
            path: RequestHistoryListScreen.routeName,
            builder: (context, state) => const RequestHistoryListScreen(),
          ),
          GoRoute(
            name: ProyectsListScreen.routeName,
            path: ProyectsListScreen.routeName,
            builder: (context, state) => const ProyectsListScreen(),
          ),
          GoRoute(
            name: EnviromentsScreen.routeName,
            path: EnviromentsScreen.routeName,
            builder: (context, state) => const EnviromentsScreen(),
          ),
          GoRoute(
            name: SettingsScreen.routeName,
            path: SettingsScreen.routeName,
            builder: (context, state) => const SettingsScreen(),
            onExit: (context, state) {
              // Desactivar la redirección cuando salimos manualmente de la pantalla
              deactivateSettingsRedirect();
              return true;
            },
          ),
          GoRoute(
            name: RequestScreen.routeName,
            path: "${RequestScreen.routeName}/:requestUuid",
            builder: (context, state) {
              final requestId = state.pathParameters['requestUuid'] ?? '';
              final endpoint = _getArgument<RestEndpoint>(state, 'endpoint');
              return RequestScreen(endpointId: requestId, endpoint: endpoint);
            },
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
