import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/infrastructure/network/network_provider.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../repositories/todo_repository.dart';
import '../usecases/get_todos_usecase.dart';
import '../usecases/get_todo_detail_usecase.dart';
import '../usecases/toggle_todo_usecase.dart';
import '../usecases/create_todo_usecase.dart';
import '../usecases/delete_todo_usecase.dart';

part 'todo_providers.g.dart';

// --- Data Layer Provider ---

@riverpod
TodoRepository todoRepository(Ref ref) {
  final httpClient = ref.watch(httpClientProvider);
  return TodoRepositoryImpl(httpClient);
}

// --- Domain Layer Providers (UseCases) ---

@riverpod
GetTodosUseCase getTodosUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodosUseCase(repository: repository);
}

@riverpod
GetTodoDetailUseCase getTodoDetailUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodoDetailUseCase(repository: repository);
}

@riverpod
ToggleTodoUseCase toggleTodoUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return ToggleTodoUseCase(repository: repository);
}

@riverpod
CreateTodoUseCase createTodoUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return CreateTodoUseCase(repository: repository);
}

@riverpod
DeleteTodoUseCase deleteTodoUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodoUseCase(repository: repository);
}
