import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/app_navigator.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigation_provider.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/pages/todo_list_page.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_app.dart';

class MockAppNavigator extends Mock implements AppNavigator {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Todo(id: 0, userId: 0, title: ''));
  });

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Buy groceries'),
    const Todo(id: 2, userId: 1, title: 'Clean the house', completed: true),
    const Todo(id: 3, userId: 1, title: 'Read a book'),
  ];

  Widget createPage({
    required MockGetTodosUseCase mockGetTodosUseCase,
  }) {
    final mockToggle = MockToggleTodoUseCase();
    final mockCreate = MockCreateTodoUseCase();
    final mockDelete = MockDeleteTodoUseCase();

    final mockNavigator = MockAppNavigator();

    return createTestApp(
      const TodoListPage(),
      overrides: [
        getTodosUseCaseProvider.overrideWith((ref) => mockGetTodosUseCase),
        toggleTodoUseCaseProvider.overrideWith((ref) => mockToggle),
        createTodoUseCaseProvider.overrideWith((ref) => mockCreate),
        deleteTodoUseCaseProvider.overrideWith((ref) => mockDelete),
        appNavigatorProvider.overrideWith((ref) => mockNavigator),
      ],
    );
  }

  goldenTest(
    'TodoListPage with data',
    fileName: 'todo_list_page_with_data',
    builder: () {
      final mock = MockGetTodosUseCase();
      when(() => mock.call())
          .thenAnswer((_) async => Result.success(testTodos));

      return GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(maxWidth: 400, maxHeight: 600),
        children: [
          GoldenTestScenario(
            name: 'with data',
            child: createPage(mockGetTodosUseCase: mock),
          ),
        ],
      );
    },
  );

  goldenTest(
    'TodoListPage error state',
    fileName: 'todo_list_page_error',
    builder: () {
      final mock = MockGetTodosUseCase();
      when(() => mock.call()).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Server error'),
        ),
      );

      return GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(maxWidth: 400, maxHeight: 600),
        children: [
          GoldenTestScenario(
            name: 'error',
            child: createPage(mockGetTodosUseCase: mock),
          ),
        ],
      );
    },
  );

  goldenTest(
    'TodoListPage empty state',
    fileName: 'todo_list_page_empty',
    builder: () {
      final mock = MockGetTodosUseCase();
      when(() => mock.call()).thenAnswer((_) async => const Result.success([]));

      return GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(maxWidth: 400, maxHeight: 600),
        children: [
          GoldenTestScenario(
            name: 'empty',
            child: createPage(mockGetTodosUseCase: mock),
          ),
        ],
      );
    },
  );
}
