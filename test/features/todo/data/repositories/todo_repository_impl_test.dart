import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/http_client_service.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';

class MockHttpClientService extends Mock implements HttpClientService {}

void main() {
  late MockHttpClientService mockHttp;
  late TodoRepositoryImpl repository;

  setUp(() {
    mockHttp = MockHttpClientService();
    repository = TodoRepositoryImpl(mockHttp);
  });

  final testTodosJson = [
    {'id': 1, 'userId': 1, 'title': 'Todo 1', 'completed': false},
    {'id': 2, 'userId': 1, 'title': 'Todo 2', 'completed': true},
  ];

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Todo 1'),
    const Todo(id: 2, userId: 1, title: 'Todo 2', completed: true),
  ];

  group('getTodos', () {
    test('returns list of todos on success', () async {
      when(() => mockHttp.get('/todos')).thenAnswer(
        (_) async => HttpResponse(statusCode: 200, data: testTodosJson),
      );

      final result = await repository.getTodos();

      expect(result, equals(testTodos));
      expect(result.length, 2);
    });

    test('throws ApiError converted from HttpException on failure', () async {
      when(() => mockHttp.get('/todos')).thenThrow(
        const HttpException(statusCode: 500, message: 'Server error'),
      );

      expect(
        () => repository.getTodos(),
        throwsA(isA<ApiError>()
            .having((e) => e.statusCode, 'statusCode', 500)
            .having((e) => e.message, 'message', 'Server error')),
      );
    });
  });

  group('getTodoById', () {
    test('returns todo on success', () async {
      when(() => mockHttp.get('/todos/1')).thenAnswer(
        (_) async => const HttpResponse(
          statusCode: 200,
          data: {'id': 1, 'userId': 1, 'title': 'Todo 1', 'completed': false},
        ),
      );

      final result = await repository.getTodoById(1);

      expect(result, equals(const Todo(id: 1, userId: 1, title: 'Todo 1')));
    });

    test('throws ApiError converted from HttpException on failure', () async {
      when(() => mockHttp.get('/todos/1')).thenThrow(
        const HttpException(statusCode: 404, message: 'Not found'),
      );

      expect(
        () => repository.getTodoById(1),
        throwsA(isA<ApiError>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.message, 'message', 'Not found')),
      );
    });
  });

  group('createTodo', () {
    test('returns created todo on success', () async {
      when(() => mockHttp.post(
            '/todos',
            body: {
              'title': 'New Todo',
              'userId': 1,
              'completed': false,
            },
          )).thenAnswer(
        (_) async => const HttpResponse(
          statusCode: 201,
          data: {
            'id': 201,
            'userId': 1,
            'title': 'New Todo',
            'completed': false
          },
        ),
      );

      final result = await repository.createTodo(title: 'New Todo', userId: 1);

      expect(result.title, 'New Todo');
      expect(result.id, 201);
    });

    test('throws ApiError converted from HttpException on failure', () async {
      when(() => mockHttp.post(
            '/todos',
            body: any(named: 'body'),
          )).thenThrow(
        const HttpException(statusCode: 500, message: 'Server error'),
      );

      expect(
        () => repository.createTodo(title: 'New Todo', userId: 1),
        throwsA(isA<ApiError>()
            .having((e) => e.statusCode, 'statusCode', 500)
            .having((e) => e.message, 'message', 'Server error')),
      );
    });
  });

  group('updateTodo', () {
    test('returns updated todo on success', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Updated', completed: true);
      when(() => mockHttp.put(
            '/todos/1',
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => const HttpResponse(
          statusCode: 200,
          data: {'id': 1, 'userId': 1, 'title': 'Updated', 'completed': true},
        ),
      );

      final result = await repository.updateTodo(todo);

      expect(result, equals(todo));
    });

    test('throws ApiError converted from HttpException on failure', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test');
      when(() => mockHttp.put(
            '/todos/1',
            body: any(named: 'body'),
          )).thenThrow(
        const HttpException(statusCode: 500, message: 'Server error'),
      );

      expect(
        () => repository.updateTodo(todo),
        throwsA(isA<ApiError>()
            .having((e) => e.statusCode, 'statusCode', 500)
            .having((e) => e.message, 'message', 'Server error')),
      );
    });
  });

  group('deleteTodo', () {
    test('completes successfully', () async {
      when(() => mockHttp.delete('/todos/1')).thenAnswer(
        (_) async => const HttpResponse(statusCode: 200, data: null),
      );

      await repository.deleteTodo(1);

      verify(() => mockHttp.delete('/todos/1')).called(1);
    });

    test('throws ApiError converted from HttpException on failure', () async {
      when(() => mockHttp.delete('/todos/1')).thenThrow(
        const HttpException(statusCode: 500, message: 'Server error'),
      );

      expect(
        () => repository.deleteTodo(1),
        throwsA(isA<ApiError>()
            .having((e) => e.statusCode, 'statusCode', 500)
            .having((e) => e.message, 'message', 'Server error')),
      );
    });
  });
}
