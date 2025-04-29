import 'package:nexust/domain/entities/settings_entity.dart';

class SettingsState {
  final SettingsEntity settings;
  final bool isLoading;
  final String? error;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.error,
  });

  factory SettingsState.initial() {
    return SettingsState(settings: SettingsEntity());
  }

  SettingsState copyWith({
    SettingsEntity? settings,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
