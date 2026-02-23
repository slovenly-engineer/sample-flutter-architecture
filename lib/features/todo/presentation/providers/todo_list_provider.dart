import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/result.dart';
import '../../models/todo.dart';
import '../../models/todo_filter.dart';
import '../../domain/providers/todo_providers.dart';

part 'todo_list_provider.g.dart';

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  Future<List<Todo>> build() async {
    final useCase = ref.watch(getTodosUseCaseProvider);
    final result = await useCase();

    return switch (result) {
      Success(:final data) => data,
      Failure(:final error) => throw Exception(error.message),
    };
  }

  Future<void> toggleTodo(Todo todo) async {
    final useCase = ref.read(toggleTodoUseCaseProvider);
    final result = await useCase(todo);

    switch (result) {
      case Success(:final data):
        state = AsyncData(
          state.value!.map((t) => t.id == data.id ? data : t).toList(),
        );
      case Failure(:final error):
        // Preserve current state, rethrow for UI to handle
        throw Exception(error.message);
    }
  }

  Future<void> addTodo(String title) async {
    final useCase = ref.read(createTodoUseCaseProvider);
    final result = await useCase(title: title, userId: 1);

    switch (result) {
      case Success(:final data):
        state = AsyncData([data, ...state.value!]);
      case Failure(:final error):
        throw Exception(error.message);
    }
  }

  Future<void> removeTodo(int id) async {
    final useCase = ref.read(deleteTodoUseCaseProvider);
    final result = await useCase(id);

    switch (result) {
      case Success():
        state = AsyncData(
          state.value!.where((t) => t.id != id).toList(),
        );
      case Failure(:final error):
        throw Exception(error.message);
    }
  }
}

@riverpod
class TodoFilterNotifier extends _$TodoFilterNotifier {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) {
    state = filter;
  }
}

@riverpod
List<Todo> filteredTodos(Ref ref) {
  final todosAsync = ref.watch(todoListNotifierProvider);
  final filter = ref.watch(todoFilterNotifierProvider);

  return todosAsync.when(
    data: (todos) => switch (filter) {
      TodoFilter.all => todos,
      TodoFilter.active => todos.where((t) => !t.completed).toList(),
      TodoFilter.completed => todos.where((t) => t.completed).toList(),
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
TodoStats todoStats(Ref ref) {
  final todosAsync = ref.watch(todoListNotifierProvider);

  return todosAsync.when(
    data: (todos) => TodoStats(
      total: todos.length,
      completed: todos.where((t) => t.completed).length,
      active: todos.where((t) => !t.completed).length,
    ),
    loading: () => const TodoStats(total: 0, completed: 0, active: 0),
    error: (_, __) => const TodoStats(total: 0, completed: 0, active: 0),
  );
}

class TodoStats {
  const TodoStats({
    required this.total,
    required this.completed,
    required this.active,
  });

  final int total;
  final int completed;
  final int active;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoStats &&
          runtimeType == other.runtimeType &&
          total == other.total &&
          completed == other.completed &&
          active == other.active;

  @override
  int get hashCode => Object.hash(total, completed, active);
}
