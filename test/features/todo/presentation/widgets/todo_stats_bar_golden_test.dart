import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_stats_bar.dart';

import '../../../../helpers/test_app.dart';

void main() {
  Widget wrapWithOverrides(TodoStats stats) {
    return createTestApp(
      const TodoStatsBar(),
      overrides: [
        todoStatsProvider.overrideWith((ref) => stats),
      ],
    );
  }

  goldenTest(
    'TodoStatsBar renders correctly',
    fileName: 'todo_stats_bar',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400, maxHeight: 100),
      children: [
        GoldenTestScenario(
          name: 'with data',
          child: wrapWithOverrides(
            const TodoStats(total: 10, completed: 6, active: 4),
          ),
        ),
        GoldenTestScenario(
          name: 'empty',
          child: wrapWithOverrides(
            const TodoStats(total: 0, completed: 0, active: 0),
          ),
        ),
      ],
    ),
  );
}
