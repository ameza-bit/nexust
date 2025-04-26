import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexust/ui/screens/auth/login_screen.dart';

class AppRoutes {
  static RouterConfig<Object>? getGoRoutes(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    List<RouteBase> routes = [
      GoRoute(
        path: "/",
        builder: (context, state) => const LoginScreen(),
        routes: [],
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
