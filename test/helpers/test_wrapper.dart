import 'package:shared_preferences/shared_preferences.dart';
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
    return MaterialApp(
      supportedLocales: const [Locale('es'), Locale('en')],
      locale: const Locale('es'),
      home: BlocProvider<SettingsCubit>.value(
        value:
            settingsCubit ?? SettingsCubit(settingsRepository, autoLoad: false),
        child: child,
      ),
    );
  }
}

/// Inicializa EasyLocalization para tests, sobrecargando la dependencia de SharedPreferences
Future<void> setupLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock para simular SharedPreferences en tests
  SharedPreferences.setMockInitialValues({});

  // No inicializar EasyLocalization completamente para evitar problemas con SharedPreferences
  // Solo configurar el binding de Flutter
}
