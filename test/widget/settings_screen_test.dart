import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nexust/domain/entities/settings_entity.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/ui/screens/settings/settings_screen.dart';
import '../mocks/mock_settings_repository.mocks.dart';

void main() {
  late MockSettingsRepository mockRepository;
  late SettingsCubit settingsCubit;

  setUp(() {
    mockRepository = MockSettingsRepository();
    when(mockRepository.getSettings()).thenAnswer(
      (_) async => SettingsEntity(
        isDarkMode: false,
        fontSize: 1.0,
        primaryColor: Colors.indigo.shade700,
        language: 'es',
        biometricEnabled: false,
      ),
    );
    when(mockRepository.saveSettings(any)).thenAnswer((_) async {});

    settingsCubit = SettingsCubit(mockRepository);
  });

  tearDown(() {
    settingsCubit.close();
  });

  testWidgets('Settings screen shows correct initial values', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify dark mode switch is off
    final darkModeSwitch = find.byType(Switch).first;
    expect(tester.widget<Switch>(darkModeSwitch).value, false);

    // Verify font size slider is at default position
    final fontSizeSlider = find.byType(Slider);
    expect(tester.widget<Slider>(fontSizeSlider).value, 1.0);

    // Verify biometric auth switch is off
    final biometricSwitch = find.byType(Switch).last;
    expect(tester.widget<Switch>(biometricSwitch).value, false);
  });

  testWidgets('Toggling dark mode switch updates the state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap the dark mode switch
    final darkModeSwitch = find.byType(Switch).first;
    await tester.tap(darkModeSwitch);
    await tester.pumpAndSettle();

    // Verify that toggleDarkMode was called with true
    verify(mockRepository.saveSettings(any)).called(1);
  });

  testWidgets('Adjusting font size slider updates the state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find the font size slider
    final fontSizeSlider = find.byType(Slider);

    // Drag the slider to a new position
    await tester.drag(fontSizeSlider, Offset(100, 0));
    await tester.pumpAndSettle();

    // Verify that updateFontSize was called
    verify(mockRepository.saveSettings(any)).called(1);
  });

  testWidgets('Toggling biometric auth switch updates the state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap the biometric auth switch
    final biometricSwitch = find.byType(Switch).last;
    await tester.tap(biometricSwitch);
    await tester.pumpAndSettle();

    // Verify that toggleBiometricAuth was called with true
    verify(mockRepository.saveSettings(any)).called(1);
  });
}
