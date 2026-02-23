import '../../../../core/infrastructure/network/http_client_service.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../models/todo.dart';

/// [TodoRepository] の具体実装。
/// Core Infrastructureの抽象（HttpClientService）のみに依存する。
/// Retrofitは不要 — パス定義・JSON変換はここで対応する。
class TodoRepositoryImpl implements TodoRepository {
  final HttpClientService _http;

  TodoRepositoryImpl(this._http);

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final response = await _http.get('/todos');
      final list = response.data as List;
      return list
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } on HttpException {
      rethrow;
    }
  }

  @override
  Future<Todo> getTodoById(int id) async {
    try {
      final response = await _http.get('/todos/$id');
      return Todo.fromJson(response.data as Map<String, dynamic>);
    } on HttpException {
      rethrow;
    }
  }

  @override
  Future<Todo> createTodo({
    required String title,
    required int userId,
  }) async {
    try {
      final response = await _http.post(
        '/todos',
        body: {
          'title': title,
          'userId': userId,
          'completed': false,
        },
      );
      return Todo.fromJson(response.data as Map<String, dynamic>);
    } on HttpException {
      rethrow;
    }
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    try {
      final response = await _http.put(
        '/todos/${todo.id}',
        body: todo.toJson(),
      );
      return Todo.fromJson(response.data as Map<String, dynamic>);
    } on HttpException {
      rethrow;
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    try {
      await _http.delete('/todos/$id');
    } on HttpException {
      rethrow;
    }
  }
}
