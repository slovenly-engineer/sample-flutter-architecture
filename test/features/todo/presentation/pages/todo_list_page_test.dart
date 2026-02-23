import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/pages/todo_list_page.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/add_todo_dialog.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_app.dart';

void main() {
  late MockGetTodosUseCase mockGetTodosUseCase;
  late MockToggleTodoUseCase mockToggleTodoUseCase;
  late MockCreateTodoUseCase mockCreateTodoUseCase;
  late MockDeleteTodoUseCase mockDeleteTodoUseCase;

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Todo 1'),
    const Todo(id: 2, userId: 1, title: 'Todo 2', completed: true),
  ];

  setUp(() {
    mockGetTodosUseCase = MockGetTodosUseCase();
    mockToggleTodoUseCase = MockToggleTodoUseCase();
    mockCreateTodoUseCase = MockCreateTodoUseCase();
    mockDeleteTodoUseCase = MockDeleteTodoUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const Todo(id: 0, userId: 0, title: ''));
  });

  Widget createPage() {
    return createTestApp(
      const TodoListPage(),
      overrides: [
        getTodosUseCaseProvider.overrideWith((ref) => mockGetTodosUseCase),
        toggleTodoUseCaseProvider.overrideWith((ref) => mockToggleTodoUseCase),
        createTodoUseCaseProvider.overrideWith((ref) => mockCreateTodoUseCase),
        deleteTodoUseCaseProvider.overrideWith((ref) => mockDeleteTodoUseCase),
      ],
    );
  }

  group('TodoListPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final completer = Completer<Result<List<Todo>>>();
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(createPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(Result.success(testTodos));
      await tester.pumpAndSettle();
    });

    testWidgets('displays todos after loading', (tester) async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
    });

    testWidgets('shows app bar with title', (tester) async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Todos'), findsOneWidget);
    });

    testWidgets('has floating action button', (tester) async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('FAB opens AddTodoDialog', (tester) async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AddTodoDialog), findsOneWidget);
    });

    testWidgets('shows error view on failure', (tester) async {
      when(() => mockGetTodosUseCase.call()).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Server error'),
        ),
      );

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows stats bar', (tester) async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('shows filter chips', (tester) async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('ALL'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('COMPLETED'), findsOneWidget);
    });
  });
}
