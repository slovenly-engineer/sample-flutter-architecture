import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/features/todo/data/api/todo_api.dart';
import 'package:sample_flutter_architecture/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';

class MockTodoApi extends Mock implements TodoApi {}

void main() {
  late MockTodoApi mockApi;
  late TodoRepositoryImpl repository;

  setUp(() {
    mockApi = MockTodoApi();
    repository = TodoRepositoryImpl(api: mockApi);
  });

  setUpAll(() {
    registerFallbackValue(
      const Todo(id: 0, userId: 0, title: ''),
    );
    registerFallbackValue(<String, dynamic>{});
  });

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Todo 1'),
    const Todo(id: 2, userId: 1, title: 'Todo 2', completed: true),
  ];

  group('getTodos', () {
    test('returns list of todos on success', () async {
      when(() => mockApi.getTodos()).thenAnswer((_) async => testTodos);

      final result = await repository.getTodos();

      expect(result, equals(testTodos));
      expect(result.length, 2);
    });

    test('throws ApiError on failure', () async {
      when(() => mockApi.getTodos()).thenThrow(Exception('Network error'));

      expect(
        () => repository.getTodos(),
        throwsA(isA<ApiError>().having(
          (e) => e.message,
          'message',
          'Failed to fetch todos',
        )),
      );
    });
  });

  group('getTodoById', () {
    test('returns todo on success', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Todo 1');
      when(() => mockApi.getTodoById(1)).thenAnswer((_) async => todo);

      final result = await repository.getTodoById(1);

      expect(result, equals(todo));
    });

    test('throws ApiError on failure', () async {
      when(() => mockApi.getTodoById(1)).thenThrow(Exception('Not found'));

      expect(
        () => repository.getTodoById(1),
        throwsA(isA<ApiError>().having(
          (e) => e.message,
          'message',
          'Failed to fetch todo',
        )),
      );
    });
  });

  group('createTodo', () {
    test('returns created todo on success', () async {
      const newTodo = Todo(id: 201, userId: 1, title: 'New Todo');
      when(() => mockApi.createTodo(any())).thenAnswer((_) async => newTodo);

      final result = await repository.createTodo(title: 'New Todo', userId: 1);

      expect(result, equals(newTodo));
      verify(() => mockApi.createTodo({
            'title': 'New Todo',
            'userId': 1,
            'completed': false,
          })).called(1);
    });

    test('throws ApiError on failure', () async {
      when(() => mockApi.createTodo(any())).thenThrow(Exception('Error'));

      expect(
        () => repository.createTodo(title: 'New Todo', userId: 1),
        throwsA(isA<ApiError>().having(
          (e) => e.message,
          'message',
          'Failed to create todo',
        )),
      );
    });
  });

  group('updateTodo', () {
    test('returns updated todo on success', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Updated', completed: true);
      when(() => mockApi.updateTodo(1, any())).thenAnswer((_) async => todo);

      final result = await repository.updateTodo(todo);

      expect(result, equals(todo));
      verify(() => mockApi.updateTodo(1, todo.toJson())).called(1);
    });

    test('throws ApiError on failure', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test');
      when(() => mockApi.updateTodo(1, any())).thenThrow(Exception('Error'));

      expect(
        () => repository.updateTodo(todo),
        throwsA(isA<ApiError>().having(
          (e) => e.message,
          'message',
          'Failed to update todo',
        )),
      );
    });
  });

  group('deleteTodo', () {
    test('completes successfully', () async {
      when(() => mockApi.deleteTodo(1)).thenAnswer((_) async {});

      await repository.deleteTodo(1);

      verify(() => mockApi.deleteTodo(1)).called(1);
    });

    test('throws ApiError on failure', () async {
      when(() => mockApi.deleteTodo(1)).thenThrow(Exception('Error'));

      expect(
        () => repository.deleteTodo(1),
        throwsA(isA<ApiError>().having(
          (e) => e.message,
          'message',
          'Failed to delete todo',
        )),
      );
    });
  });
}
