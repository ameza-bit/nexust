import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/enums/language.dart';
import 'package:nexust/data/models/setting.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:nexust/presentation/blocs/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(SettingsState.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _settingsRepository.getSettings();
      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void updateIsDarkMode(bool isDarkMode) {
    _updateSetting(state.settings.copyWith(isDarkMode: isDarkMode));
  }

  void updatePrimaryColor(Color primaryColor) {
    _updateSetting(state.settings.copyWith(primaryColor: primaryColor));
  }

  void updateFontSize(double fontSize) {
    _updateSetting(state.settings.copyWith(fontSize: fontSize));
  }

  void updateLanguage(Language language) {
    _updateSetting(state.settings.copyWith(language: language));
  }

  void updateBiometricEnabled(bool biometricEnabled) {
    _updateSetting(state.settings.copyWith(biometricEnabled: biometricEnabled));
  }

  void _updateSetting(Settings newSetting) {
    try {
      _settingsRepository.saveSettings(newSetting);
      emit(state.copyWith(settings: newSetting));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
