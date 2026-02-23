import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_entity.freezed.dart';
part 'app_settings_entity.g.dart';

@freezed
class AppSettingsEntity with _$AppSettingsEntity {
  const factory AppSettingsEntity({
    @Default('ja') String locale,
    @Default(false) bool isDarkMode,
    @Default(false) bool isOnboardingCompleted,
  }) = _AppSettingsEntity;

  factory AppSettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsEntityFromJson(json);
}
