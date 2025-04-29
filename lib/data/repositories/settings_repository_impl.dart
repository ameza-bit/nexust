import 'package:flutter/material.dart';
import 'package:nexust/domain/entities/settings_entity.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _primaryColorKey = 'primary_color';
  static const String _languageKey = 'language';
  static const String _biometricEnabledKey = 'biometric_enabled';

  @override
  Future<SettingsEntity> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return SettingsEntity(
      isDarkMode: prefs.getBool(_isDarkModeKey) ?? false,
      fontSize: prefs.getDouble(_fontSizeKey) ?? 1.0,
      primaryColor: Color(prefs.getInt(_primaryColorKey) ?? 0xFF3949AB),
      language: prefs.getString(_languageKey) ?? 'es',
      biometricEnabled: prefs.getBool(_biometricEnabledKey) ?? false,
    );
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isDarkModeKey, settings.isDarkMode);
    await prefs.setDouble(_fontSizeKey, settings.fontSize);
    await prefs.setInt(_primaryColorKey, settings.primaryColor.value);
    await prefs.setString(_languageKey, settings.language);
    await prefs.setBool(_biometricEnabledKey, settings.biometricEnabled);
  }
}
