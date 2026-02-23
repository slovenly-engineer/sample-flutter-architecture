import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/network/dio_client.dart';
import 'package:sample_flutter_architecture/features/todo/data/api/todo_api.dart';
import 'package:sample_flutter_architecture/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/create_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todo_detail_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/toggle_todo_usecase.dart';

void main() {
  group('Todo Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          dioClientProvider.overrideWith((ref) => Dio()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('todoApiProvider creates TodoApi', () {
      final api = container.read(todoApiProvider);
      expect(api, isA<TodoApi>());
    });

    test('todoRepositoryProvider creates TodoRepositoryImpl', () {
      final repo = container.read(todoRepositoryProvider);
      expect(repo, isA<TodoRepositoryImpl>());
    });

    test('getTodosUseCaseProvider creates GetTodosUseCase', () {
      final useCase = container.read(getTodosUseCaseProvider);
      expect(useCase, isA<GetTodosUseCase>());
    });

    test('getTodoDetailUseCaseProvider creates GetTodoDetailUseCase', () {
      final useCase = container.read(getTodoDetailUseCaseProvider);
      expect(useCase, isA<GetTodoDetailUseCase>());
    });

    test('toggleTodoUseCaseProvider creates ToggleTodoUseCase', () {
      final useCase = container.read(toggleTodoUseCaseProvider);
      expect(useCase, isA<ToggleTodoUseCase>());
    });

    test('createTodoUseCaseProvider creates CreateTodoUseCase', () {
      final useCase = container.read(createTodoUseCaseProvider);
      expect(useCase, isA<CreateTodoUseCase>());
    });

    test('deleteTodoUseCaseProvider creates DeleteTodoUseCase', () {
      final useCase = container.read(deleteTodoUseCaseProvider);
      expect(useCase, isA<DeleteTodoUseCase>());
    });
  });
}
