import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_architecture/core/ui/components/app_empty_view.dart';

void main() {
  goldenTest(
    'AppEmptyView renders correctly',
    fileName: 'app_empty_view',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const AppEmptyView(message: 'No items found.'),
        ),
        GoldenTestScenario(
          name: 'custom icon',
          child: const AppEmptyView(
            message: 'No todos found.',
            icon: Icons.checklist,
          ),
        ),
        GoldenTestScenario(
          name: 'with action',
          child: AppEmptyView(
            message: 'Nothing here.',
            action: FilledButton(
              onPressed: () {},
              child: const Text('Add Item'),
            ),
          ),
        ),
      ],
    ),
  );
}
