import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/domain/entities/settings_entity.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository, {bool autoLoad = true})
    : super(SettingsState.initial()) {
    if (autoLoad) {
      loadSettings();
    }
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _settingsRepository.getSettings();
      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    final newSettings = state.settings.copyWith(isDarkMode: value);
    await _updateSettings(newSettings);
  }

  Future<void> updateFontSize(double value) async {
    final newSettings = state.settings.copyWith(fontSize: value);
    await _updateSettings(newSettings);
  }

  Future<void> updatePrimaryColor(Color color) async {
    final newSettings = state.settings.copyWith(primaryColor: color);
    await _updateSettings(newSettings);
  }

  Future<void> updateLanguage(String language) async {
    final newSettings = state.settings.copyWith(language: language);
    await _updateSettings(newSettings);
  }

  Future<void> toggleBiometricAuth(bool value) async {
    final newSettings = state.settings.copyWith(biometricEnabled: value);
    await _updateSettings(newSettings);
  }

  Future<void> _updateSettings(SettingsEntity newSettings) async {
    emit(state.copyWith(settings: newSettings));
    try {
      await _settingsRepository.saveSettings(newSettings);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
