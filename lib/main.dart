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
import 'package:nexust/data/services/connectivity_service.dart';
import 'package:nexust/data/services/firestore_service.dart';
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
import 'package:nexust/presentation/blocs/sync/sync_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';
import 'package:nexust/core/themes/main_theme.dart';
import 'package:nexust/presentation/blocs/sync/sync_state.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    name: 'Nexust',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configurar servicios
  final SettingsRepository settingsRepository = SettingsRepositoryImpl();
  final HttpService httpService = HttpService();
  final RequestRepository requestRepository = RequestRepositoryImpl(
    httpService,
  );

  // Servicio de Firestore y conectividad
  final ConnectivityService connectivityService = ConnectivityService();
  final FirestoreService firestoreService = FirestoreService();

  // Repositorios que usan Firestore
  final ProjectRepository projectRepository = ProjectRepositoryImpl(
    firestoreService: firestoreService,
  );
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
        // Nuevo SyncCubit para gestionar sincronización
        BlocProvider<SyncCubit>(
          create: (context) => SyncCubit(connectivityService),
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
          builder: (context, child) {
            // Agregar un widget de sincronización en la parte superior de la aplicación
            return BlocBuilder<SyncCubit, SyncState>(
              builder: (context, syncState) {
                return Stack(
                  children: [
                    // El contenido principal de la aplicación
                    child!,

                    // Indicador de estado de sincronización (solo visible cuando está sincronizando o hay un error)
                    if (syncState.syncStatus == SyncStatus.syncing ||
                        syncState.syncStatus == SyncStatus.error ||
                        syncState.connectionStatus == ConnectionStatus.offline)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Material(
                          elevation: 4,
                          child: Container(
                            color: _getSyncStatusColor(
                              syncState,
                              Theme.of(context),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            child: SafeArea(
                              top: true,
                              bottom: false,
                              child: Row(
                                children: [
                                  _getSyncStatusIcon(syncState),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _getSyncStatusMessage(syncState),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (syncState.connectionStatus ==
                                          ConnectionStatus.online &&
                                      syncState.syncStatus !=
                                          SyncStatus.syncing)
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<SyncCubit>()
                                            .forceSynchronization();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Reintentar'),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // Obtener el color adecuado según el estado de sincronización
  Color _getSyncStatusColor(SyncState state, ThemeData theme) {
    if (state.connectionStatus == ConnectionStatus.offline) {
      return Colors.grey.shade700;
    }

    switch (state.syncStatus) {
      case SyncStatus.syncing:
        return theme.primaryColor;
      case SyncStatus.error:
        return Colors.red.shade700;
      default:
        return theme.primaryColor;
    }
  }

  // Obtener el ícono adecuado según el estado de sincronización
  Widget _getSyncStatusIcon(SyncState state) {
    if (state.connectionStatus == ConnectionStatus.offline) {
      return const Icon(Icons.wifi_off, color: Colors.white, size: 18);
    }

    switch (state.syncStatus) {
      case SyncStatus.syncing:
        return const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case SyncStatus.error:
        return const Icon(Icons.error_outline, color: Colors.white, size: 18);
      default:
        return const Icon(Icons.sync, color: Colors.white, size: 18);
    }
  }

  // Obtener el mensaje adecuado según el estado de sincronización
  String _getSyncStatusMessage(SyncState state) {
    if (state.connectionStatus == ConnectionStatus.offline) {
      return 'Trabajando sin conexión. Los cambios se sincronizarán cuando vuelvas a estar en línea.';
    }

    switch (state.syncStatus) {
      case SyncStatus.syncing:
        return 'Sincronizando con la nube...';
      case SyncStatus.error:
        return state.errorMessage ?? 'Error al sincronizar. Intenta de nuevo.';
      default:
        return 'Sincronizando datos...';
    }
  }
}
