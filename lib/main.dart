import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/core/themes/main_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('es')],
      path: 'assets/translations',
      fallbackLocale: Locale('es'),
      child: const MainApp(),
    ),
  );
}

// ignore: prefer-match-file-name
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRoutes.getGoRoutes(navigatorKey);

    return MaterialApp.router(
      title: 'Nexust',
      routerConfig: routerConfig,
      theme: MainTheme.lightTheme.copyWith(
        // primaryColor: state.settings.primaryColor,
        textTheme: MainTheme.lightTheme.textTheme.apply(
          // fontSizeFactor: state.settings.fontSize,
        ),
      ),
      darkTheme: MainTheme.darkTheme.copyWith(
        // primaryColor: state.settings.primaryColor,
        textTheme: MainTheme.darkTheme.textTheme.apply(
          // fontSizeFactor: state.settings.fontSize,
        ),
      ),
      // themeMode: state.settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      // locale: Locale(state.settings.language),
    );
  }
}
