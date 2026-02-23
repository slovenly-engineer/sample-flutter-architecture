import '../../models/todo.dart';

/// Todoデータ操作のRepository抽象インターフェース（Domain層）。
/// Data層でこのインターフェースを実装する。
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> getTodoById(int id);
  Future<Todo> createTodo({required String title, required int userId});
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
}
