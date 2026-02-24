import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigation_provider.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_list_tile.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockGetTodosUseCase mockGetTodosUseCase;
  late MockToggleTodoUseCase mockToggleTodoUseCase;
  late MockCreateTodoUseCase mockCreateTodoUseCase;
  late MockDeleteTodoUseCase mockDeleteTodoUseCase;
  late MockAppNavigator mockAppNavigator;

  const activeTodo = Todo(id: 1, userId: 1, title: 'Active Todo');
  const completedTodo = Todo(
    id: 2,
    userId: 1,
    title: 'Completed Todo',
    completed: true,
  );

  setUp(() {
    mockGetTodosUseCase = MockGetTodosUseCase();
    mockToggleTodoUseCase = MockToggleTodoUseCase();
    mockCreateTodoUseCase = MockCreateTodoUseCase();
    mockDeleteTodoUseCase = MockDeleteTodoUseCase();
    mockAppNavigator = MockAppNavigator();

    when(() => mockGetTodosUseCase.call()).thenAnswer(
      (_) async => const Result.success([activeTodo, completedTodo]),
    );
  });

  setUpAll(() {
    registerFallbackValue(const Todo(id: 0, userId: 0, title: ''));
  });

  Widget createWidget(Todo todo) {
    return ProviderScope(
      overrides: [
        getTodosUseCaseProvider.overrideWith((ref) => mockGetTodosUseCase),
        toggleTodoUseCaseProvider.overrideWith((ref) => mockToggleTodoUseCase),
        createTodoUseCaseProvider.overrideWith((ref) => mockCreateTodoUseCase),
        deleteTodoUseCaseProvider.overrideWith((ref) => mockDeleteTodoUseCase),
        appNavigatorProvider.overrideWith((ref) => mockAppNavigator),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ListView(children: [TodoListTile(todo: todo)]),
        ),
      ),
    );
  }

  group('TodoListTile', () {
    testWidgets('displays todo title', (tester) async {
      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      expect(find.text('Active Todo'), findsOneWidget);
    });

    testWidgets('shows checkbox unchecked for active todo', (tester) async {
      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('shows checkbox checked for completed todo', (tester) async {
      await tester.pumpWidget(createWidget(completedTodo));
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('applies strikethrough for completed todo', (tester) async {
      await tester.pumpWidget(createWidget(completedTodo));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Completed Todo'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('no strikethrough for active todo', (tester) async {
      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Active Todo'));
      expect(text.style?.decoration, isNull);
    });

    testWidgets('tapping checkbox calls toggleTodo', (tester) async {
      when(() => mockToggleTodoUseCase.call(any())).thenAnswer(
        (_) async => Result.success(activeTodo.copyWith(completed: true)),
      );

      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(() => mockToggleTodoUseCase.call(any())).called(1);
    });

    testWidgets('tapping tile navigates to todo detail', (tester) async {
      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Active Todo'));
      await tester.pump();

      verify(() => mockAppNavigator.goToTodoDetail('1')).called(1);
    });

    testWidgets('swiping triggers removeTodo', (tester) async {
      when(
        () => mockDeleteTodoUseCase.call(1),
      ).thenAnswer((_) async => const Result.success(null));

      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      verify(() => mockDeleteTodoUseCase.call(1)).called(1);
    });
  });
}
