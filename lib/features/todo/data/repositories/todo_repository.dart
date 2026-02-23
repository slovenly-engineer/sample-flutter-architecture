import '../../models/todo.dart';

/// Repository interface for Todo data operations.
/// This abstraction allows easy mocking in tests.
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> getTodoById(int id);
  Future<Todo> createTodo({required String title, required int userId});
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
}
