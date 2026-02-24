import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/pages/todo_detail_page.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_app.dart';

void main() {
  late MockGetTodoDetailUseCase mockGetTodoDetailUseCase;

  const testTodo = Todo(id: 1, userId: 1, title: 'Test Todo', completed: false);

  const completedTodo = Todo(
    id: 2,
    userId: 1,
    title: 'Completed Todo',
    completed: true,
  );

  setUp(() {
    mockGetTodoDetailUseCase = MockGetTodoDetailUseCase();
  });

  Widget createPage({int todoId = 1}) {
    return createTestApp(
      TodoDetailPage(todoId: todoId),
      overrides: [
        getTodoDetailUseCaseProvider.overrideWith(
          (ref) => mockGetTodoDetailUseCase,
        ),
      ],
    );
  }

  group('TodoDetailPage', () {
    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<Result<Todo>>();
      when(
        () => mockGetTodoDetailUseCase.call(1),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Result.success(testTodo));
      await tester.pumpAndSettle();
    });

    testWidgets('displays app bar with title', (tester) async {
      when(
        () => mockGetTodoDetailUseCase.call(1),
      ).thenAnswer((_) async => const Result.success(testTodo));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Todo Detail'), findsOneWidget);
    });

    testWidgets('displays active todo details', (tester) async {
      when(
        () => mockGetTodoDetailUseCase.call(1),
      ).thenAnswer((_) async => const Result.success(testTodo));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Test Todo'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('User ID: 1'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    });

    testWidgets('displays completed todo details', (tester) async {
      when(
        () => mockGetTodoDetailUseCase.call(2),
      ).thenAnswer((_) async => const Result.success(completedTodo));

      await tester.pumpWidget(createPage(todoId: 2));
      await tester.pumpAndSettle();

      expect(find.text('Completed Todo'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows error view on failure', (tester) async {
      when(() => mockGetTodoDetailUseCase.call(1)).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 404, message: 'Not found'),
        ),
      );

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('retry button triggers reload', (tester) async {
      // First: always fail
      when(() => mockGetTodoDetailUseCase.call(1)).thenAnswer(
        (_) async =>
            const Result.failure(ApiError(statusCode: 500, message: 'Error')),
      );

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      // Now: change mock to succeed on next call
      when(
        () => mockGetTodoDetailUseCase.call(1),
      ).thenAnswer((_) async => const Result.success(testTodo));

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // After retry, the todo should be displayed
      expect(find.text('Test Todo'), findsOneWidget);
    });
  });
}
