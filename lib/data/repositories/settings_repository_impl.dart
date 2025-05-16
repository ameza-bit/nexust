import 'package:nexust/data/models/setting.dart';
import 'package:nexust/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return settingsFromJson(prefs.getString('settings') ?? '{}');
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', settingsToJson(settings));
  }
}
