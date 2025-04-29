import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nexust/domain/entities/settings_entity.dart';
import 'package:nexust/presentation/blocs/settings/settings_cubit.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';
import '../mocks/mock_settings_repository.mocks.dart';

void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    when(
      mockRepository.getSettings(),
    ).thenAnswer((_) async => SettingsEntity());
  });

  test('initial state is correct', () {
    final settingsCubit = SettingsCubit(mockRepository, autoLoad: false);
    expect(settingsCubit.state.settings, isA<SettingsEntity>());
    expect(settingsCubit.state.isLoading, false);
    expect(settingsCubit.state.error, null);
    settingsCubit.close();
  });

  blocTest<SettingsCubit, SettingsState>(
    'toggleDarkMode changes isDarkMode setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {
        return;
      });
      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.toggleDarkMode(true),
    expect:
        () => [
          predicate<SettingsState>(
            (state) => state.settings.isDarkMode == true && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'setLanguage changes language setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {
        return;
      });
      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.updateLanguage('en'),
    expect:
        () => [
          predicate<SettingsState>(
            (state) => state.settings.language == 'en' && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'setPrimaryColor changes primary color setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {
        return;
      });
      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.updatePrimaryColor(Colors.blue),
    expect:
        () => [
          predicate<SettingsState>(
            (state) =>
                state.settings.primaryColor == Colors.blue && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'setFontSize changes font size setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {
        return;
      });
      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.updateFontSize(1.5),
    expect:
        () => [
          predicate<SettingsState>(
            (state) => state.settings.fontSize == 1.5 && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'toggleBiometricAuth changes biometric enabled setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {
        return;
      });
      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.toggleBiometricAuth(true),
    expect:
        () => [
          predicate<SettingsState>(
            (state) =>
                state.settings.biometricEnabled == true && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'loadSettings emits correct states',
    build: () {
      final testSettings = SettingsEntity(
        isDarkMode: true,
        fontSize: 1.1,
        primaryColor: Colors.blue,
        language: 'en',
        biometricEnabled: true,
      );

      when(mockRepository.getSettings()).thenAnswer((_) async => testSettings);

      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.loadSettings(),
    expect:
        () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>(
            (state) =>
                state.settings.isDarkMode == true &&
                state.settings.fontSize == 1.1 &&
                state.settings.primaryColor == Colors.blue &&
                state.settings.language == 'en' &&
                state.settings.biometricEnabled == true &&
                state.isLoading == false,
          ),
        ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'loadSettings handles errors correctly',
    build: () {
      when(
        mockRepository.getSettings(),
      ).thenThrow(Exception('Failed to load settings'));
      return SettingsCubit(mockRepository, autoLoad: false);
    },
    act: (cubit) => cubit.loadSettings(),
    expect:
        () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>(
            (state) => state.error != null && state.isLoading == false,
          ),
        ],
  );
}
