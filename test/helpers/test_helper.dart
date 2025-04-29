import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';

/// Wrapper que proporciona los proveedores necesarios para tests de widgets
class TestWrapper extends StatelessWidget {
  final Widget child;
  final SettingsRepository settingsRepository;
  final SettingsCubit? settingsCubit;

  const TestWrapper({
    super.key,
    required this.child,
    required this.settingsRepository,
    this.settingsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('es'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      child: BlocProvider<SettingsCubit>.value(
        value:
            settingsCubit ?? SettingsCubit(settingsRepository, autoLoad: false),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: const Locale('es'),
              home: child,
            );
          },
        ),
      ),
    );
  }
}

/// Inicializa EasyLocalization para tests
Future<void> setupLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}
