import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/data/models/rest_endpoint.dart';
import 'package:nexust/presentation/screens/auth/login_screen.dart';
import 'package:nexust/presentation/screens/auth/splash_screen.dart';
import 'package:nexust/presentation/screens/collections/proyects_list_screen.dart';
import 'package:nexust/presentation/screens/home/home_screen.dart';
import 'package:nexust/presentation/screens/home/tabs_screen.dart';
import 'package:nexust/presentation/screens/request/request_history_list_screen.dart';
import 'package:nexust/presentation/screens/request/request_screen.dart';
import 'package:nexust/presentation/screens/settings/enviroments_screen.dart';
import 'package:nexust/presentation/screens/settings/settings_screen.dart';

class AppRoutes {
  static RouterConfig<Object>? getGoRoutes(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    List<RouteBase> routes = [
      GoRoute(
        path: "/",
        builder: (context, state) => const SplashScreen(),
        routes: [
          GoRoute(
            name: HomeScreen.routeName,
            path: HomeScreen.routeName,
            builder: (context, state) => const TabsScreen(),
            routes: [
              GoRoute(
                name: LoginScreen.routeName,
                path: LoginScreen.routeName,
                builder: (context, state) => const LoginScreen(),
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
              ),
              GoRoute(
                name: RequestScreen.routeName,
                path: "${RequestScreen.routeName}/:requestUuid",
                builder: (context, state) {
                  final requestId = state.pathParameters['requestUuid'] ?? '';
                  final endpoint = _getArgument<RestEndpoint>(
                    state,
                    'endpoint',
                  );
                  return RequestScreen(
                    endpointId: requestId,
                    endpoint: endpoint,
                  );
                },
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
