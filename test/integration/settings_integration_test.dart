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
  });

  testWidgets('Settings changes persist across widget rebuilds', (
    WidgetTester tester,
  ) async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    final SettingsRepository repository = SettingsRepositoryImpl();
    final settingsCubit = SettingsCubit(repository);

    // Esperar a que se carguen los ajustes iniciales
    await Future.delayed(const Duration(milliseconds: 100));

    // Build the widget
    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: repository,
        settingsCubit: settingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Toggle dark mode
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    // Esperar a que se guarden los ajustes
    await Future.delayed(const Duration(milliseconds: 50));

    // Destroy and recreate the widget to test persistence
    await tester.pumpWidget(Container());

    final newSettingsCubit = SettingsCubit(repository);

    // Wait for the cubit to load settings
    await Future.delayed(const Duration(milliseconds: 100));

    // Build the widget again
    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: repository,
        settingsCubit: newSettingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verificar que el switch de modo oscuro está activado
    final darkModeSwitch = find.byType(Switch).first;
    expect(tester.widget<Switch>(darkModeSwitch).value, true);

    // Cleanup
    settingsCubit.close();
    newSettingsCubit.close();
  });
}
