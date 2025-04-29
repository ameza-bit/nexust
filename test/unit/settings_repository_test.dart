import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexust/data/repositories/settings_repository_impl.dart';
import 'package:nexust/domain/entities/settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsRepositoryImpl repository;

  setUp(() {
    repository = SettingsRepositoryImpl();
  });

  test(
    'getSettings returns default values when SharedPreferences is empty',
    () async {
      SharedPreferences.setMockInitialValues({});

      final settings = await repository.getSettings();

      expect(settings.isDarkMode, false);
      expect(settings.fontSize, 1.0);
      expect(settings.primaryColor.value, 0xFF3949AB); // Indigo 700
      expect(settings.language, 'es');
      expect(settings.biometricEnabled, false);
    },
  );

  test('saveSettings and getSettings work correctly', () async {
    SharedPreferences.setMockInitialValues({});

    final testSettings = SettingsEntity(
      isDarkMode: true,
      fontSize: 1.2,
      primaryColor: Colors.red,
      language: 'en',
      biometricEnabled: true,
    );

    await repository.saveSettings(testSettings);
    final loadedSettings = await repository.getSettings();

    expect(loadedSettings.isDarkMode, true);
    expect(loadedSettings.fontSize, 1.2);
    expect(loadedSettings.primaryColor.value, Colors.red.value);
    expect(loadedSettings.language, 'en');
    expect(loadedSettings.biometricEnabled, true);
  });
}
