import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/ui/themes/main_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializar el sistema de widgets de Flutter.
  await EasyLocalization.ensureInitialized(); //Inicializa el sistema de traduccion/multilenguaje

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('es')],
      path: 'assets/translations',
      fallbackLocale: Locale('es'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nexust',
      routerConfig: AppRoutes.getGoRoutes(navigatorKey),
      theme: MainTheme.lightTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
