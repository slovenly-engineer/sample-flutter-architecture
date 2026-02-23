import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  const isRunningInCi = bool.fromEnvironment('CI', defaultValue: false);

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: AppTheme.light,
      platformGoldensConfig: const PlatformGoldensConfig(
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}
