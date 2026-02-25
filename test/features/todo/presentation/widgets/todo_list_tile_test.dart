import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_list_tile.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockTodoListAction mockAction;

  const activeTodo = Todo(id: 1, userId: 1, title: 'Active Todo');
  const completedTodo = Todo(
    id: 2,
    userId: 1,
    title: 'Completed Todo',
    completed: true,
  );

  setUp(() {
    mockAction = MockTodoListAction();
  });

  setUpAll(() {
    registerFallbackValue(const Todo(id: 0, userId: 0, title: ''));
  });

  Widget createWidget(Todo todo) {
    return ProviderScope(
      overrides: [todoListActionProvider.overrideWith((ref) => mockAction)],
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

    testWidgets('tapping checkbox calls action.toggleTodo', (tester) async {
      when(() => mockAction.toggleTodo(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(() => mockAction.toggleTodo(activeTodo)).called(1);
    });

    testWidgets('tapping tile calls action.goToTodoDetail', (tester) async {
      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Active Todo'));
      await tester.pump();

      verify(() => mockAction.goToTodoDetail(1)).called(1);
    });

    testWidgets('swiping calls action.removeTodo', (tester) async {
      when(() => mockAction.removeTodo(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidget(activeTodo));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      verify(() => mockAction.removeTodo(1)).called(1);
    });
  });
}
