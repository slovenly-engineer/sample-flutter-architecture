import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/data/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/delete_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late DeleteTodoUseCase useCase;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = DeleteTodoUseCase(repository: mockRepository);
  });

  group('DeleteTodoUseCase', () {
    test('returns Success when deletion succeeds', () async {
      when(() => mockRepository.deleteTodo(1)).thenAnswer((_) async {});

      final result = await useCase(1);

      expect(result, isA<Success<void>>());
      verify(() => mockRepository.deleteTodo(1)).called(1);
    });

    test('returns Failure when repository throws ApiError', () async {
      when(() => mockRepository.deleteTodo(1)).thenThrow(
        const ApiError(statusCode: 500, message: 'Failed to delete todo'),
      );

      final result = await useCase(1);

      expect(result, isA<Failure<void>>());
      final error = (result as Failure<void>).error;
      expect(error.statusCode, 500);
      expect(error.message, 'Failed to delete todo');
    });

    test('returns Failure with generic message on unexpected error', () async {
      when(() => mockRepository.deleteTodo(1))
          .thenThrow(Exception('Network error'));

      final result = await useCase(1);

      expect(result, isA<Failure<void>>());
      final error = (result as Failure<void>).error;
      expect(error.statusCode, 0);
      expect(error.message, 'Unexpected error');
      expect(error.detail, contains('Network error'));
    });
  });
}
