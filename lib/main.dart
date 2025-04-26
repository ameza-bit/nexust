import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/ui/theme/main_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nexust',
      routerConfig: AppRoutes.getGoRoutes(navigatorKey),
      theme: MainTheme.lightTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('es', 'MX'), const Locale('en', 'US')],
      locale: const Locale('es', 'MX'),
    );
  }
}
