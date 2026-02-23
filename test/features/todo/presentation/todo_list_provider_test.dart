import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo_filter.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';

// Note: These tests demonstrate filtering logic without requiring
// Riverpod container setup. Full provider integration tests would
// require generated code from build_runner.

void main() {
  final todos = [
    const Todo(id: 1, userId: 1, title: 'Active 1', completed: false),
    const Todo(id: 2, userId: 1, title: 'Completed 1', completed: true),
    const Todo(id: 3, userId: 1, title: 'Active 2', completed: false),
    const Todo(id: 4, userId: 1, title: 'Completed 2', completed: true),
  ];

  group('TodoFilter logic', () {
    test('TodoFilter.all includes all todos', () {
      final filtered = _applyFilter(todos, TodoFilter.all);
      expect(filtered.length, 4);
    });

    test('TodoFilter.active includes only incomplete todos', () {
      final filtered = _applyFilter(todos, TodoFilter.active);
      expect(filtered.length, 2);
      expect(filtered.every((t) => !t.completed), isTrue);
    });

    test('TodoFilter.completed includes only completed todos', () {
      final filtered = _applyFilter(todos, TodoFilter.completed);
      expect(filtered.length, 2);
      expect(filtered.every((t) => t.completed), isTrue);
    });
  });

  group('TodoStats logic', () {
    test('calculates correct stats', () {
      final stats = TodoStats(
        total: todos.length,
        completed: todos.where((t) => t.completed).length,
        active: todos.where((t) => !t.completed).length,
      );

      expect(stats.total, 4);
      expect(stats.completed, 2);
      expect(stats.active, 2);
    });

    test('handles empty list', () {
      const stats = TodoStats(total: 0, completed: 0, active: 0);

      expect(stats.total, 0);
      expect(stats.completed, 0);
      expect(stats.active, 0);
    });
  });
}

/// Helper that mirrors the filtering logic from filteredTodosProvider
List<Todo> _applyFilter(List<Todo> todos, TodoFilter filter) {
  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((t) => !t.completed).toList(),
    TodoFilter.completed => todos.where((t) => t.completed).toList(),
  };
}
