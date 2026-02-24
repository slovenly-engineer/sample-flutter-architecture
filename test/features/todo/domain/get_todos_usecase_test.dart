import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late GetTodosUseCase useCase;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodosUseCase(repository: mockRepository);
  });

  final testTodos = [
    const Todo(id: 1, userId: 1, title: 'Test Todo 1', completed: false),
    const Todo(id: 2, userId: 1, title: 'Test Todo 2', completed: true),
  ];

  group('GetTodosUseCase', () {
    test(
      'returns Success with list of todos when repository succeeds',
      () async {
        when(
          () => mockRepository.getTodos(),
        ).thenAnswer((_) async => testTodos);

        final result = await useCase();

        expect(result, isA<Success<List<Todo>>>());
        final data = (result as Success<List<Todo>>).data;
        expect(data, equals(testTodos));
        expect(data.length, 2);
        verify(() => mockRepository.getTodos()).called(1);
      },
    );

    test('returns Failure when repository throws ApiError', () async {
      when(
        () => mockRepository.getTodos(),
      ).thenThrow(const ApiError(statusCode: 500, message: 'Server error'));

      final result = await useCase();

      expect(result, isA<Failure<List<Todo>>>());
      final error = (result as Failure<List<Todo>>).error;
      expect(error.statusCode, 500);
      expect(error.message, 'Server error');
    });

    test('returns Failure with generic message on unexpected error', () async {
      when(
        () => mockRepository.getTodos(),
      ).thenThrow(Exception('Network error'));

      final result = await useCase();

      expect(result, isA<Failure<List<Todo>>>());
      final error = (result as Failure<List<Todo>>).error;
      expect(error.statusCode, 0);
      expect(error.message, 'Unexpected error');
    });
  });
}
