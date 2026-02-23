import '../../../../core/models/api_error.dart';
import '../../../../core/models/result.dart';
import '../../models/todo.dart';
import '../../data/repositories/todo_repository.dart';

class ToggleTodoUseCase {
  ToggleTodoUseCase({required this.repository});

  final TodoRepository repository;

  Future<Result<Todo>> call(Todo todo) async {
    try {
      final updated = todo.copyWith(completed: !todo.completed);
      final result = await repository.updateTodo(updated);
      return Result.success(result);
    } on ApiError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        ApiError(
          statusCode: 0,
          message: 'Unexpected error',
          detail: e.toString(),
        ),
      );
    }
  }
}
