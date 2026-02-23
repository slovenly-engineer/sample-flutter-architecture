import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo_filter.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';

import '../../../../helpers/mocks.dart';

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

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        getTodosUseCaseProvider.overrideWith((ref) => mockGetTodosUseCase),
        toggleTodoUseCaseProvider.overrideWith((ref) => mockToggleTodoUseCase),
        createTodoUseCaseProvider.overrideWith((ref) => mockCreateTodoUseCase),
        deleteTodoUseCaseProvider.overrideWith((ref) => mockDeleteTodoUseCase),
      ],
    );
  }

  group('TodoListNotifier', () {
    test('build fetches todos successfully', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      // Trigger the provider
      final subscription = container.listen(
        todoListNotifierProvider,
        (_, __) {},
      );

      // Wait for async resolution
      await container.read(todoListNotifierProvider.future);

      final state = subscription.read();
      expect(state.value, testTodos);
    });

    test('build throws on failure', () async {
      when(() => mockGetTodosUseCase.call()).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Error'),
        ),
      );

      final container = createContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(todoListNotifierProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('toggleTodo updates the todo in state', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      const toggledTodo =
          Todo(id: 1, userId: 1, title: 'Todo 1', completed: true);
      when(() => mockToggleTodoUseCase.call(any()))
          .thenAnswer((_) async => const Result.success(toggledTodo));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      await container
          .read(todoListNotifierProvider.notifier)
          .toggleTodo(testTodos[0]);

      final state = await container.read(todoListNotifierProvider.future);
      expect(state.first.completed, true);
    });

    test('addTodo prepends the new todo', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      const newTodo = Todo(id: 3, userId: 1, title: 'New Todo');
      when(() => mockCreateTodoUseCase.call(
            title: any(named: 'title'),
            userId: any(named: 'userId'),
          )).thenAnswer((_) async => const Result.success(newTodo));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      await container
          .read(todoListNotifierProvider.notifier)
          .addTodo('New Todo');

      final state = await container.read(todoListNotifierProvider.future);
      expect(state.length, 3);
      expect(state.first.title, 'New Todo');
    });

    test('removeTodo removes the todo from state', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      when(() => mockDeleteTodoUseCase.call(any()))
          .thenAnswer((_) async => const Result.success(null));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      await container.read(todoListNotifierProvider.notifier).removeTodo(1);

      final state = await container.read(todoListNotifierProvider.future);
      expect(state.length, 1);
      expect(state.first.id, 2);
    });

    test('toggleTodo throws on failure', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      when(() => mockToggleTodoUseCase.call(any())).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Toggle failed'),
        ),
      );

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      expect(
        () => container
            .read(todoListNotifierProvider.notifier)
            .toggleTodo(testTodos[0]),
        throwsA(isA<Exception>()),
      );
    });

    test('addTodo throws on failure', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      when(() => mockCreateTodoUseCase.call(
            title: any(named: 'title'),
            userId: any(named: 'userId'),
          )).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Create failed'),
        ),
      );

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      expect(
        () => container
            .read(todoListNotifierProvider.notifier)
            .addTodo('Fail Todo'),
        throwsA(isA<Exception>()),
      );
    });

    test('removeTodo throws on failure', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      when(() => mockDeleteTodoUseCase.call(any())).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Delete failed'),
        ),
      );

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      expect(
        () => container.read(todoListNotifierProvider.notifier).removeTodo(1),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('TodoFilterNotifier', () {
    test('initial state is TodoFilter.all', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final filter = container.read(todoFilterNotifierProvider);
      expect(filter, TodoFilter.all);
    });

    test('setFilter changes the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(todoFilterNotifierProvider.notifier)
          .setFilter(TodoFilter.active);

      expect(container.read(todoFilterNotifierProvider), TodoFilter.active);
    });
  });

  group('filteredTodos', () {
    test('returns all todos with TodoFilter.all', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      final filtered = container.read(filteredTodosProvider);
      expect(filtered.length, 2);
    });

    test('returns only active todos with TodoFilter.active', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      container
          .read(todoFilterNotifierProvider.notifier)
          .setFilter(TodoFilter.active);

      final filtered = container.read(filteredTodosProvider);
      expect(filtered.length, 1);
      expect(filtered.first.completed, false);
    });

    test('returns only completed todos with TodoFilter.completed', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      container
          .read(todoFilterNotifierProvider.notifier)
          .setFilter(TodoFilter.completed);

      final filtered = container.read(filteredTodosProvider);
      expect(filtered.length, 1);
      expect(filtered.first.completed, true);
    });

    test('returns empty when loading', () {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      // Don't await - read while still loading
      final filtered = container.read(filteredTodosProvider);
      expect(filtered, isEmpty);
    });
  });

  group('todoStats', () {
    test('returns correct stats', () async {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(todoListNotifierProvider.future);

      final stats = container.read(todoStatsProvider);
      expect(stats.total, 2);
      expect(stats.active, 1);
      expect(stats.completed, 1);
    });

    test('returns zeros when loading', () {
      when(() => mockGetTodosUseCase.call())
          .thenAnswer((_) async => Result.success(testTodos));

      final container = createContainer();
      addTearDown(container.dispose);

      final stats = container.read(todoStatsProvider);
      expect(stats.total, 0);
      expect(stats.completed, 0);
      expect(stats.active, 0);
    });
  });
}
