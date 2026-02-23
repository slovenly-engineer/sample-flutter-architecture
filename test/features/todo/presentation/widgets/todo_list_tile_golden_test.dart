import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigation_provider.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_list_tile.dart';

import '../../../../helpers/mocks.dart';

void main() {
  const activeTodo = Todo(id: 1, userId: 1, title: 'Buy groceries');
  const completedTodo =
      Todo(id: 2, userId: 1, title: 'Clean the house', completed: true);

  final mockGetTodosUseCase = MockGetTodosUseCase();
  final mockToggleTodoUseCase = MockToggleTodoUseCase();
  final mockCreateTodoUseCase = MockCreateTodoUseCase();
  final mockDeleteTodoUseCase = MockDeleteTodoUseCase();
  final mockAppNavigator = MockAppNavigator();

  when(() => mockGetTodosUseCase.call()).thenAnswer(
      (_) async => const Result.success([activeTodo, completedTodo]));

  Widget wrapWithProviders(Widget child) {
    return ProviderScope(
      overrides: [
        getTodosUseCaseProvider.overrideWith((ref) => mockGetTodosUseCase),
        toggleTodoUseCaseProvider.overrideWith((ref) => mockToggleTodoUseCase),
        createTodoUseCaseProvider.overrideWith((ref) => mockCreateTodoUseCase),
        deleteTodoUseCaseProvider.overrideWith((ref) => mockDeleteTodoUseCase),
        appNavigatorProvider.overrideWith((ref) => mockAppNavigator),
      ],
      child: child,
    );
  }

  goldenTest(
    'TodoListTile renders correctly',
    fileName: 'todo_list_tile',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 400),
      children: [
        GoldenTestScenario(
          name: 'active',
          child: wrapWithProviders(
            const Material(child: TodoListTile(todo: activeTodo)),
          ),
        ),
        GoldenTestScenario(
          name: 'completed',
          child: wrapWithProviders(
            const Material(child: TodoListTile(todo: completedTodo)),
          ),
        ),
      ],
    ),
  );
}
