import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/api/todo_api.dart';
import '../../data/repositories/todo_repository.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../usecases/get_todos_usecase.dart';
import '../usecases/get_todo_detail_usecase.dart';
import '../usecases/toggle_todo_usecase.dart';
import '../usecases/create_todo_usecase.dart';
import '../usecases/delete_todo_usecase.dart';

part 'todo_providers.g.dart';

// --- Data Layer Providers ---

@riverpod
TodoApi todoApi(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return TodoApi(dio);
}

@riverpod
TodoRepository todoRepository(Ref ref) {
  final api = ref.watch(todoApiProvider);
  return TodoRepositoryImpl(api: api);
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
