import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/repositories/settings_repository_impl.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/ui/screens/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Settings changes persist across widget rebuilds', (
    WidgetTester tester,
  ) async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    final SettingsRepository repository = SettingsRepositoryImpl();
    final settingsCubit = SettingsCubit(repository);

    // Esperar a que se carguen los ajustes iniciales
    await Future.delayed(Duration(milliseconds: 100));

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Toggle dark mode
    final darkModeSwitch = find.byType(Switch).first;
    await tester.tap(darkModeSwitch);
    await tester.pumpAndSettle();

    // Esperar a que se guarden los ajustes
    await Future.delayed(Duration(milliseconds: 50));

    // Destroy and recreate the widget to test persistence
    await tester.pumpWidget(Container());

    final newSettingsCubit = SettingsCubit(repository);

    // Wait for the cubit to load settings
    await Future.delayed(Duration(milliseconds: 100));

    // Build the widget again
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: newSettingsCubit,
          child: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify settings persisted
    expect(
      tester.widget<Switch>(find.byType(Switch).first).value,
      true,
    ); // Dark mode is on

    // Cleanup
    settingsCubit.close();
    newSettingsCubit.close();
  });
}
