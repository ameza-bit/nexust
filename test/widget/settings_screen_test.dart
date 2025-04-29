import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/ui/screens/settings/settings_screen.dart';
import 'package:nexust/domain/entities/settings_entity.dart';
import '../mocks/mock_settings_repository.mocks.dart';
import '../helpers/test_helper.dart';

void main() {
  late MockSettingsRepository mockRepository;
  late SettingsCubit settingsCubit;

  setUpAll(() async {
    await setupLocalization();
  });

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

    settingsCubit = SettingsCubit(mockRepository, autoLoad: false);
  });

  tearDown(() {
    settingsCubit.close();
  });

  testWidgets('Settings screen shows correct initial values', (
    WidgetTester tester,
  ) async {
    // Emitir el estado inicial para que esté disponible antes de construir el widget
    settingsCubit.emit(
      settingsCubit.state.copyWith(
        settings: SettingsEntity(
          isDarkMode: false,
          fontSize: 1.0,
          primaryColor: Colors.indigo.shade700,
          language: 'es',
          biometricEnabled: false,
        ),
      ),
    );

    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: mockRepository,
        settingsCubit: settingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify dark mode switch is off
    expect(find.byType(Switch), findsWidgets);
    final switches = find.byType(Switch).evaluate().toList();
    expect(switches.isNotEmpty, true);

    // Verificar el primer Switch (modo oscuro)
    final switchWidget = tester.widget<Switch>(find.byType(Switch).first);
    expect(switchWidget.value, false);

    // Verify font size slider is at default position
    expect(find.byType(Slider), findsOneWidget);
    expect(tester.widget<Slider>(find.byType(Slider)).value, 1.0);

    // Verificar que el switch de biometría esté apagado
    final biometricSwitch = tester.widget<Switch>(find.byType(Switch).at(1));
    expect(biometricSwitch.value, false);
  });

  testWidgets('Toggling dark mode switch updates the state', (
    WidgetTester tester,
  ) async {
    // Emitir el estado inicial
    settingsCubit.emit(
      settingsCubit.state.copyWith(
        settings: SettingsEntity(
          isDarkMode: false,
          fontSize: 1.0,
          primaryColor: Colors.indigo.shade700,
          language: 'es',
          biometricEnabled: false,
        ),
      ),
    );

    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: mockRepository,
        settingsCubit: settingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap the dark mode switch
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    // Verify that toggleDarkMode was called with true
    verify(mockRepository.saveSettings(any)).called(1);
  });

  testWidgets('Adjusting font size slider updates the state', (
    WidgetTester tester,
  ) async {
    // Emitir el estado inicial
    settingsCubit.emit(
      settingsCubit.state.copyWith(
        settings: SettingsEntity(
          isDarkMode: false,
          fontSize: 1.0,
          primaryColor: Colors.indigo.shade700,
          language: 'es',
          biometricEnabled: false,
        ),
      ),
    );

    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: mockRepository,
        settingsCubit: settingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Find the font size slider
    final slider = find.byType(Slider);
    expect(slider, findsOneWidget);

    // Drag the slider to a new position
    await tester.drag(slider, const Offset(100.0, 0.0));
    await tester.pumpAndSettle();

    // Verify that updateFontSize was called
    verify(mockRepository.saveSettings(any)).called(1);
  });

  testWidgets('Toggling biometric auth switch updates the state', (
    WidgetTester tester,
  ) async {
    // Emitir el estado inicial
    settingsCubit.emit(
      settingsCubit.state.copyWith(
        settings: SettingsEntity(
          isDarkMode: false,
          fontSize: 1.0,
          primaryColor: Colors.indigo.shade700,
          language: 'es',
          biometricEnabled: false,
        ),
      ),
    );

    await tester.pumpWidget(
      TestWrapper(
        settingsRepository: mockRepository,
        settingsCubit: settingsCubit,
        child: const SettingsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap the biometric auth switch (el segundo Switch que aparece en la pantalla)
    await tester.tap(find.byType(Switch).at(1));
    await tester.pumpAndSettle();

    // Verify that toggleBiometricAuth was called with true
    verify(mockRepository.saveSettings(any)).called(1);
  });
}
