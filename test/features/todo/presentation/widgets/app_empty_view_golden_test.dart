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
        const GoldenTestScenario(
          name: 'default',
          child: AppEmptyView(message: 'No items found.'),
        ),
        const GoldenTestScenario(
          name: 'custom icon',
          child: AppEmptyView(
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
