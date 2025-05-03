import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/routes/app_routes.dart';
import 'package:nexust/data/repositories/auth_repository_impl.dart';
import 'package:nexust/data/repositories/collections_repository_impl.dart';
import 'package:nexust/data/repositories/environment_repository_impl.dart';
import 'package:nexust/data/repositories/project_member_repository_impl.dart';
import 'package:nexust/data/repositories/project_repository_impl.dart';
import 'package:nexust/data/repositories/request_repository_impl.dart';
import 'package:nexust/data/repositories/settings_repository_impl.dart';
import 'package:nexust/data/services/auth_service.dart';
import 'package:nexust/data/services/http_service.dart';
import 'package:nexust/domain/repositories/auth_repository.dart';
import 'package:nexust/domain/repositories/environment_repository.dart';
import 'package:nexust/domain/repositories/project_member_repository.dart';
import 'package:nexust/domain/repositories/project_repository.dart';
import 'package:nexust/domain/repositories/request_repository.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/firebase_options.dart';
import 'package:nexust/presentation/blocs/auth/auth_cubit.dart';
import 'package:nexust/presentation/blocs/collections/collections_cubit.dart';
import 'package:nexust/presentation/blocs/environments/environment_cubit.dart';
import 'package:nexust/presentation/blocs/projects/project_cubit.dart';
import 'package:nexust/presentation/blocs/request/request_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';
import 'package:nexust/core/themes/main_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    name: 'Nexust',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SettingsRepository settingsRepository = SettingsRepositoryImpl();
  final HttpService httpService = HttpService();
  final RequestRepository requestRepository = RequestRepositoryImpl(
    httpService,
  );

  final ProjectRepository projectRepository = ProjectRepositoryImpl();
  final ProjectMemberRepository projectMemberRepository =
      ProjectMemberRepositoryImpl();
  final EnvironmentRepository environmentRepository =
      EnvironmentRepositoryImpl();

  // Configurar servicio de autenticación
  final authService = AuthService();
  final AuthRepository authRepository = AuthRepositoryImpl(authService);

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
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository, projectRepository),
        ),
        BlocProvider<ProjectCubit>(
          create:
              (context) =>
                  ProjectCubit(projectRepository, projectMemberRepository),
        ),
        BlocProvider<EnvironmentCubit>(
          create:
              (context) => EnvironmentCubit(
                environmentRepository,
                context.read<ProjectCubit>(),
              ),
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
      buildWhen: (previous, current) {
        // Solo reconstruir cuando cambian propiedades que afectan al tema o idioma
        return previous.settings.isDarkMode != current.settings.isDarkMode ||
            previous.settings.primaryColor != current.settings.primaryColor ||
            previous.settings.fontSize != current.settings.fontSize ||
            previous.settings.language != current.settings.language;
      },
      builder: (context, state) {
        final routerConfig = AppRoutes.getGoRoutes(navigatorKey);

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
