import 'entities/app_settings_entity.dart';

/// アプリ設定のRepository抽象（横断的関心事）。
abstract class AppSettingsRepository {
  Future<AppSettingsEntity> getSettings();
  Future<void> saveSettings(AppSettingsEntity settings);
}
