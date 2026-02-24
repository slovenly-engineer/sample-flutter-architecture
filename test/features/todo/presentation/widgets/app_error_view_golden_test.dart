import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_architecture/core/ui/components/app_error_view.dart';

void main() {
  goldenTest(
    'AppErrorView renders correctly',
    fileName: 'app_error_view',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
      children: [
        GoldenTestScenario(
          name: 'with retry button',
          child: AppErrorView(message: 'Something went wrong', onRetry: () {}),
        ),
        GoldenTestScenario(
          name: 'without retry button',
          child: const AppErrorView(message: 'An error occurred'),
        ),
      ],
    ),
  );
}
