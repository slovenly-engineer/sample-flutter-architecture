import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_architecture/core/ui/components/app_loading_indicator.dart';

void main() {
  goldenTest(
    'AppLoadingIndicator renders correctly',
    fileName: 'app_loading_indicator',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
      children: [
        GoldenTestScenario(
          name: 'default size',
          child: const TickerMode(enabled: false, child: AppLoadingIndicator()),
        ),
        GoldenTestScenario(
          name: 'custom size',
          child: const TickerMode(
            enabled: false,
            child: AppLoadingIndicator(size: 64),
          ),
        ),
      ],
    ),
  );
}
