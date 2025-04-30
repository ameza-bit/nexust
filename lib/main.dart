// lib/main.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/data/repositories/collections_repository_impl.dart';
import 'package:nexust/data/repositories/request_repository_impl.dart';
import 'package:nexust/data/repositories/settings_repository_impl.dart';
import 'package:nexust/data/services/http_service.dart';
import 'package:nexust/domain/repositories/request_repository.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/presentation/blocs/collections/collections_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';
import 'package:nexust/ui/themes/main_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final SettingsRepository settingsRepository = SettingsRepositoryImpl();
  final HttpService httpService = HttpService();
  final RequestRepository requestRepository = RequestRepositoryImpl(
    httpService,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(settingsRepository),
        ),
        BlocProvider<CollectionsCubit>(
          create: (context) => CollectionsCubit(CollectionsRepositoryImpl()),
        ),
        BlocProvider<RequestCubit>(
          create: (context) => RequestCubit(requestRepository),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('es')],
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Nexust',
          routerConfig: AppRoutes.getGoRoutes(navigatorKey),
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
          themeMode:
              state.settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: Locale(state.settings.language),
        );
      },
    );
  }
}
