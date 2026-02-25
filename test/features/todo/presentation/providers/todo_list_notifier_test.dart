import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo_filter.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockTodoRepository mockRepository;

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Todo 1'),
    const Todo(id: 2, userId: 1, title: 'Todo 2', completed: true),
  ];

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [todoRepositoryProvider.overrideWith((ref) => mockRepository)],
    );
  }

  group('TodoListNotifier', () {
    test('build fetches todos from repository successfully', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      final subscription = container.listen(todoListProvider, (_, _) {});

      await container.read(todoListProvider.future);

      final state = subscription.read();
      expect(state.value, testTodos);
    });

    test('build throws on repository failure', () async {
      when(
        () => mockRepository.getTodos(),
      ).thenThrow(const ApiError(statusCode: 500, message: 'Error'));

      final container = createContainer();
      addTearDown(container.dispose);

      final sub = container.listen(todoListProvider, (_, _) {});

      await pumpEventQueue();

      final state = sub.read();
      expect(state.hasError, isTrue);
      expect(state.error, isA<ApiError>());

      sub.close();
    });

    test('updateTodo replaces the matching todo in state', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      const updatedTodo = Todo(
        id: 1,
        userId: 1,
        title: 'Todo 1',
        completed: true,
      );
      container.read(todoListProvider.notifier).updateTodo(updatedTodo);

      final state = await container.read(todoListProvider.future);
      expect(state.first.completed, true);
      expect(state.first.id, 1);
    });

    test('prependTodo adds the new todo at the beginning', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      const newTodo = Todo(id: 3, userId: 1, title: 'New Todo');
      container.read(todoListProvider.notifier).prependTodo(newTodo);

      final state = await container.read(todoListProvider.future);
      expect(state.length, 3);
      expect(state.first.title, 'New Todo');
    });

    test('removeTodoById removes the todo from state', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      container.read(todoListProvider.notifier).removeTodoById(1);

      final state = await container.read(todoListProvider.future);
      expect(state.length, 1);
      expect(state.first.id, 2);
    });
  });

  group('TodoFilterNotifier', () {
    test('initial state is TodoFilter.all', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final filter = container.read(todoFilterProvider);
      expect(filter, TodoFilter.all);
    });

    test('setFilter changes the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoFilterProvider.notifier).setFilter(TodoFilter.active);

      expect(container.read(todoFilterProvider), TodoFilter.active);
    });
  });

  group('filteredTodos', () {
    test('returns all todos with TodoFilter.all', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      final filtered = container.read(filteredTodosProvider);
      expect(filtered.length, 2);
    });

    test('returns only active todos with TodoFilter.active', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      container.read(todoFilterProvider.notifier).setFilter(TodoFilter.active);

      final filtered = container.read(filteredTodosProvider);
      expect(filtered.length, 1);
      expect(filtered.first.completed, false);
    });

    test('returns only completed todos with TodoFilter.completed', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      container
          .read(todoFilterProvider.notifier)
          .setFilter(TodoFilter.completed);

      final filtered = container.read(filteredTodosProvider);
      expect(filtered.length, 1);
      expect(filtered.first.completed, true);
    });

    test('returns empty when loading', () {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      // Don't await - read while still loading
      final filtered = container.read(filteredTodosProvider);
      expect(filtered, isEmpty);
    });
  });

  group('todoStats', () {
    test('returns correct stats', () async {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListProvider.future);

      final stats = container.read(todoStatsProvider);
      expect(stats.total, 2);
      expect(stats.active, 1);
      expect(stats.completed, 1);
    });

    test('returns zeros when loading', () {
      when(() => mockRepository.getTodos()).thenAnswer((_) async => testTodos);

      final container = createContainer();
      addTearDown(container.dispose);

      final stats = container.read(todoStatsProvider);
      expect(stats.total, 0);
      expect(stats.completed, 0);
      expect(stats.active, 0);
    });
  });
}
