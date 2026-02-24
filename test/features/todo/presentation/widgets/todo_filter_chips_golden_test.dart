import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo_filter.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_filter_chips.dart';

import '../../../../helpers/test_app.dart';

void main() {
  Widget wrapWithFilter(TodoFilter filter) {
    return createTestAppWithScaffold(
      const TodoFilterChips(),
      overrides: [
        todoFilterProvider.overrideWith(() => _TestFilterNotifier(filter)),
      ],
    );
  }

  goldenTest(
    'TodoFilterChips renders correctly',
    fileName: 'todo_filter_chips',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400, maxHeight: 80),
      children: [
        GoldenTestScenario(
          name: 'all selected',
          child: wrapWithFilter(TodoFilter.all),
        ),
        GoldenTestScenario(
          name: 'active selected',
          child: wrapWithFilter(TodoFilter.active),
        ),
        GoldenTestScenario(
          name: 'completed selected',
          child: wrapWithFilter(TodoFilter.completed),
        ),
      ],
    ),
  );
}

class _TestFilterNotifier extends TodoFilterNotifier {
  _TestFilterNotifier(this._initial);
  final TodoFilter _initial;

  @override
  TodoFilter build() => _initial;
}
