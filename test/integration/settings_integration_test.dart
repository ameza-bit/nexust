import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexust/data/repositories/settings_repository_impl.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/ui/screens/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/test_helper.dart';

void main() {
  setUpAll(() async {
    await setupLocalization();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Settings changes persist across widget rebuilds', (
    WidgetTester tester,
  ) async {
    // Setup
    final SettingsRepository repository = SettingsRepositoryImpl();
    final settingsCubit = SettingsCubit(repository);

    // Asegurar que el cubit haya completado la carga inicial
    await settingsCubit.loadSettings();

    // Build the widget
    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: repository,
        settingsCubit: settingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Cambiar directamente el estado usando el cubit en lugar de interactuar con la UI
    settingsCubit.toggleDarkMode(true);
    await tester.pumpAndSettle();

    // Asegurar que SharedPreferences haya persistido los cambios
    await tester.pumpAndSettle();

    // Destroy and recreate the widget to test persistence
    await tester.pumpWidget(Container());

    final newSettingsCubit = SettingsCubit(repository);

    // Esperar a que el cubit cargue la configuración guardada
    await newSettingsCubit.loadSettings();

    // Build the widget again
    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: repository,
        settingsCubit: newSettingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verificar que se guardó la configuración revisando el cubit directamente
    expect(newSettingsCubit.state.settings.isDarkMode, true);

    // Cleanup
    settingsCubit.close();
    newSettingsCubit.close();
  });
}
