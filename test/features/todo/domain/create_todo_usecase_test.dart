import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/create_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late CreateTodoUseCase useCase;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = CreateTodoUseCase(repository: mockRepository);
  });

  group('CreateTodoUseCase', () {
    test('returns Failure when title is empty', () async {
      final result = await useCase(title: '', userId: 1);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.statusCode, 400);
      expect(error.message, 'Title cannot be empty');
      verifyNever(() => mockRepository.createTodo(
            title: any(named: 'title'),
            userId: any(named: 'userId'),
          ));
    });

    test('returns Failure when title is only whitespace', () async {
      final result = await useCase(title: '   ', userId: 1);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.message, 'Title cannot be empty');
    });

    test('returns Success when title is valid', () async {
      const newTodo = Todo(id: 201, userId: 1, title: 'New Todo');
      when(() => mockRepository.createTodo(
            title: 'New Todo',
            userId: 1,
          )).thenAnswer((_) async => newTodo);

      final result = await useCase(title: 'New Todo', userId: 1);

      expect(result, isA<Success<Todo>>());
      final data = (result as Success<Todo>).data;
      expect(data.title, 'New Todo');
      verify(() => mockRepository.createTodo(title: 'New Todo', userId: 1))
          .called(1);
    });

    test('trims title before creating', () async {
      const newTodo = Todo(id: 201, userId: 1, title: 'Trimmed');
      when(() => mockRepository.createTodo(
            title: 'Trimmed',
            userId: 1,
          )).thenAnswer((_) async => newTodo);

      final result = await useCase(title: '  Trimmed  ', userId: 1);

      expect(result, isA<Success<Todo>>());
      verify(() => mockRepository.createTodo(title: 'Trimmed', userId: 1))
          .called(1);
    });

    test('returns Failure when repository throws ApiError', () async {
      when(() => mockRepository.createTodo(
            title: any(named: 'title'),
            userId: any(named: 'userId'),
          )).thenThrow(
        const ApiError(statusCode: 500, message: 'Server error'),
      );

      final result = await useCase(title: 'Test', userId: 1);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.statusCode, 500);
    });

    test('returns Failure with unexpected error', () async {
      when(() => mockRepository.createTodo(
            title: any(named: 'title'),
            userId: any(named: 'userId'),
          )).thenThrow(Exception('network error'));

      final result = await useCase(title: 'Test', userId: 1);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.statusCode, 0);
      expect(error.message, 'Unexpected error');
    });
  });
}
