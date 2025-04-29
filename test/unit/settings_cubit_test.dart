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
  late SettingsCubit settingsCubit;

  setUp(() {
    mockRepository = MockSettingsRepository();
    when(
      mockRepository.getSettings(),
    ).thenAnswer((_) async => SettingsEntity());
    settingsCubit = SettingsCubit(mockRepository);
  });

  tearDown(() {
    settingsCubit.close();
  });

  test('initial state is correct', () {
    expect(settingsCubit.state.settings, isA<SettingsEntity>());
    expect(settingsCubit.state.isLoading, false);
    expect(settingsCubit.state.error, null);
  });

  blocTest<SettingsCubit, SettingsState>(
    'toggleDarkMode changes isDarkMode setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {});
      return settingsCubit;
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
    'updateFontSize changes fontSize setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {});
      return settingsCubit;
    },
    act: (cubit) => cubit.updateFontSize(1.2),
    expect:
        () => [
          predicate<SettingsState>(
            (state) => state.settings.fontSize == 1.2 && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'updatePrimaryColor changes primaryColor setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {});
      return settingsCubit;
    },
    act: (cubit) => cubit.updatePrimaryColor(Colors.red),
    expect:
        () => [
          predicate<SettingsState>(
            (state) =>
                state.settings.primaryColor == Colors.red && !state.isLoading,
          ),
        ],
    verify: (_) {
      verify(mockRepository.saveSettings(any)).called(1);
    },
  );

  blocTest<SettingsCubit, SettingsState>(
    'updateLanguage changes language setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {});
      return settingsCubit;
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
    'toggleBiometricAuth changes biometricEnabled setting',
    build: () {
      when(mockRepository.saveSettings(any)).thenAnswer((_) async {});
      return settingsCubit;
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

      return SettingsCubit(mockRepository);
    },
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
      return SettingsCubit(mockRepository);
    },
    expect:
        () => [
          predicate<SettingsState>((state) => state.isLoading == true),
          predicate<SettingsState>(
            (state) => state.error != null && state.isLoading == false,
          ),
        ],
  );
}
