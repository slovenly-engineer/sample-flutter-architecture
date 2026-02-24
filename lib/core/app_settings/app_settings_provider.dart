import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_settings_repository.dart';

part 'app_settings_provider.g.dart';

/// AppSettingsRepositoryのProvider。
/// 具体実装はData層で提供し、overrideで差し替える。
@riverpod
AppSettingsRepository appSettingsRepository(
  Ref ref,
) => throw UnimplementedError(
  'appSettingsRepositoryProvider must be overridden with a concrete implementation',
);
