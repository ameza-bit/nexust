import 'package:nexust/core/services/preferences.dart';
import 'package:nexust/data/models/setting.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Settings getSettings() => Preferences.settings;

  @override
  void saveSettings(Settings settings) async => Preferences.settings = settings;
}
