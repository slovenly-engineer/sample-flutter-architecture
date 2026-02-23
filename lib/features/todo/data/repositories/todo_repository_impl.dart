import '../../../../core/models/api_error.dart';
import '../../models/todo.dart';
import '../api/todo_api.dart';
import 'todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({required this.api});

  final TodoApi api;

  @override
  Future<List<Todo>> getTodos() async {
    try {
      return await api.getTodos();
    } catch (e) {
      throw ApiError(
        statusCode: 500,
        message: 'Failed to fetch todos',
        detail: e.toString(),
      );
    }
  }

  @override
  Future<Todo> getTodoById(int id) async {
    try {
      return await api.getTodoById(id);
    } catch (e) {
      throw ApiError(
        statusCode: 500,
        message: 'Failed to fetch todo',
        detail: e.toString(),
      );
    }
  }

  @override
  Future<Todo> createTodo({
    required String title,
    required int userId,
  }) async {
    try {
      return await api.createTodo({
        'title': title,
        'userId': userId,
        'completed': false,
      });
    } catch (e) {
      throw ApiError(
        statusCode: 500,
        message: 'Failed to create todo',
        detail: e.toString(),
      );
    }
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    try {
      return await api.updateTodo(todo.id, todo.toJson());
    } catch (e) {
      throw ApiError(
        statusCode: 500,
        message: 'Failed to update todo',
        detail: e.toString(),
      );
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    try {
      await api.deleteTodo(id);
    } catch (e) {
      throw ApiError(
        statusCode: 500,
        message: 'Failed to delete todo',
        detail: e.toString(),
      );
    }
  }
}
