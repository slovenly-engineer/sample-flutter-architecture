import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/data/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/toggle_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late ToggleTodoUseCase useCase;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = ToggleTodoUseCase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const Todo(id: 0, userId: 0, title: ''),
    );
  });

  group('ToggleTodoUseCase', () {
    test('toggles completed from false to true', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test', completed: false);
      const toggled = Todo(id: 1, userId: 1, title: 'Test', completed: true);

      when(() => mockRepository.updateTodo(any()))
          .thenAnswer((_) async => toggled);

      final result = await useCase(todo);

      expect(result, isA<Success<Todo>>());
      final data = (result as Success<Todo>).data;
      expect(data.completed, true);

      final captured =
          verify(() => mockRepository.updateTodo(captureAny())).captured;
      expect((captured.first as Todo).completed, true);
    });

    test('toggles completed from true to false', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test', completed: true);
      const toggled = Todo(id: 1, userId: 1, title: 'Test', completed: false);

      when(() => mockRepository.updateTodo(any()))
          .thenAnswer((_) async => toggled);

      final result = await useCase(todo);

      expect(result, isA<Success<Todo>>());
      final data = (result as Success<Todo>).data;
      expect(data.completed, false);
    });

    test('returns Failure when repository throws ApiError', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test');

      when(() => mockRepository.updateTodo(any())).thenThrow(
        const ApiError(statusCode: 500, message: 'Update failed'),
      );

      final result = await useCase(todo);

      expect(result, isA<Failure<Todo>>());
      final error = (result as Failure<Todo>).error;
      expect(error.message, 'Update failed');
    });
  });
}
