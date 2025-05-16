import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/enums/language.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/core/themes/main_theme.dart';
import 'package:nexust/data/repositories/settings_repository_impl.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/firebase_options.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    name: kIsWeb ? null : 'Nexust',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SettingsRepository settingsRepository = SettingsRepositoryImpl();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(settingsRepository),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('es'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('es'),
        child: const MainApp(),
      ),
    ),
  );
}

// ignore: prefer-match-file-name
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRoutes.getGoRoutes(navigatorKey);

    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) {
        // Solo reconstruir cuando cambian propiedades que afectan al tema o idioma
        return previous.settings.themeMode != current.settings.themeMode ||
            previous.settings.primaryColor != current.settings.primaryColor ||
            previous.settings.fontSize != current.settings.fontSize ||
            previous.settings.language != current.settings.language;
      },
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Nexust',
          routerConfig: routerConfig,
          theme: MainTheme.lightTheme.copyWith(
            primaryColor: state.settings.primaryColor,
            textTheme: MainTheme.lightTheme.textTheme.apply(
              fontSizeFactor: state.settings.fontSize,
            ),
          ),
          darkTheme: MainTheme.darkTheme.copyWith(
            primaryColor: state.settings.primaryColor,
            textTheme: MainTheme.darkTheme.textTheme.apply(
              fontSizeFactor: state.settings.fontSize,
            ),
          ),
          themeMode: state.settings.themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: Locale(state.settings.language.code),
        );
      },
    );
  }
}
