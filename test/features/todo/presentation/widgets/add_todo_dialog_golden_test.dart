import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/add_todo_dialog.dart';

void main() {
  goldenTest(
    'AddTodoDialog renders correctly',
    fileName: 'add_todo_dialog',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400, maxHeight: 250),
      children: [
        GoldenTestScenario(
          name: 'empty',
          child: ProviderScope(
            child: Theme(
              data: AppTheme.light,
              child: const Material(child: AddTodoDialog()),
            ),
          ),
        ),
      ],
    ),
  );
}
