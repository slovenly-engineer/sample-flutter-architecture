import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/pages/todo_detail_page.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_app.dart';

void main() {
  const activeTodo = Todo(id: 1, userId: 1, title: 'Buy groceries');
  const completedTodo = Todo(
    id: 2,
    userId: 1,
    title: 'Clean the house',
    completed: true,
  );

  Widget createPage({
    required int todoId,
    required MockGetTodoDetailUseCase mock,
  }) {
    return createTestApp(
      TodoDetailPage(todoId: todoId),
      overrides: [getTodoDetailUseCaseProvider.overrideWith((ref) => mock)],
    );
  }

  goldenTest(
    'TodoDetailPage active todo',
    fileName: 'todo_detail_page_active',
    builder: () {
      final mock = MockGetTodoDetailUseCase();
      when(
        () => mock.call(1),
      ).thenAnswer((_) async => const Result.success(activeTodo));

      return GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'active todo',
            child: createPage(todoId: 1, mock: mock),
          ),
        ],
      );
    },
  );

  goldenTest(
    'TodoDetailPage completed todo',
    fileName: 'todo_detail_page_completed',
    builder: () {
      final mock = MockGetTodoDetailUseCase();
      when(
        () => mock.call(2),
      ).thenAnswer((_) async => const Result.success(completedTodo));

      return GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'completed todo',
            child: createPage(todoId: 2, mock: mock),
          ),
        ],
      );
    },
  );

  goldenTest(
    'TodoDetailPage error state',
    fileName: 'todo_detail_page_error',
    builder: () {
      final mock = MockGetTodoDetailUseCase();
      when(() => mock.call(1)).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 404, message: 'Not found'),
        ),
      );

      return GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'error',
            child: createPage(todoId: 1, mock: mock),
          ),
        ],
      );
    },
  );
}
