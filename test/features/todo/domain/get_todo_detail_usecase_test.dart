import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todo_detail_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late GetTodoDetailUseCase useCase;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodoDetailUseCase(repository: mockRepository);
  });

  group('GetTodoDetailUseCase', () {
    test('returns Success with todo when repository succeeds', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test Todo');
      when(() => mockRepository.getTodoById(1)).thenAnswer((_) async => todo);

      final result = await useCase(1);

      expect(result, isA<Success<Todo>>());
      final data = (result as Success<Todo>).data;
      expect(data.id, 1);
      expect(data.title, 'Test Todo');
      verify(() => mockRepository.getTodoById(1)).called(1);
    });

    test('returns Failure when repository throws ApiError', () async {
      when(() => mockRepository.getTodoById(1)).thenThrow(
        const ApiError(statusCode: 404, message: 'Todo not found'),
      );

      final result = await useCase(1);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.statusCode, 404);
      expect(error.message, 'Todo not found');
    });

    test('returns Failure with generic message on unexpected error', () async {
      when(() => mockRepository.getTodoById(1))
          .thenThrow(Exception('Network error'));

      final result = await useCase(1);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.statusCode, 0);
      expect(error.message, 'Unexpected error');
      expect(error.detail, contains('Network error'));
    });
  });
}
