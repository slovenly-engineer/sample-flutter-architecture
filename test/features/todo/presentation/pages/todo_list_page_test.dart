import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/pages/todo_list_page.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/add_todo_dialog.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_app.dart';

void main() {
  late MockTodoRepository mockRepository;
  late MockTodoListAction mockAction;

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Todo 1'),
    const Todo(id: 2, userId: 1, title: 'Todo 2', completed: true),
  ];

  setUp(() {
    mockRepository = MockTodoRepository();
    mockAction = MockTodoListAction();
  });

  setUpAll(() {
    registerFallbackValue(const Todo(id: 0, userId: 0, title: ''));
  });

  Widget createPage() {
    return createTestApp(
      const TodoListPage(),
      overrides: [
        todoRepositoryProvider.overrideWith((ref) => mockRepository),
        todoListActionProvider.overrideWith((ref) => mockAction),
      ],
    );
  }

  group('TodoListPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final completer = Completer<List<Todo>>();
      when(() => mockRepository.getTodos()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(testTodos);
      await tester.pumpAndSettle();
    });

    testWidgets('displays todos after loading', (tester) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
    });

    testWidgets('shows app bar with title', (tester) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Todos'), findsOneWidget);
    });

    testWidgets('has floating action button', (tester) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('FAB opens AddTodoDialog', (tester) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AddTodoDialog), findsOneWidget);
    });

    testWidgets('shows error view on failure', (tester) async {
      when(() => mockRepository.getTodos()).thenThrow(Exception('Error'));

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows stats bar', (tester) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('submitting AddTodoDialog calls action.addTodo', (
      tester,
    ) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);
      when(() => mockAction.addTodo(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter text and submit via the Add button
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      verify(() => mockAction.addTodo('New Todo')).called(1);
    });

    testWidgets('shows filter chips', (tester) async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      await tester.pumpWidget(createPage());
      await tester.pumpAndSettle();

      expect(find.text('ALL'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('COMPLETED'), findsOneWidget);
    });
  });
}
