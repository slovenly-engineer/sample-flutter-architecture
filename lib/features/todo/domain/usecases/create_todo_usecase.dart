import '../../../../core/models/api_error.dart';
import '../../../../core/models/result.dart';
import '../../models/todo.dart';
import '../repositories/todo_repository.dart';

class CreateTodoUseCase {
  CreateTodoUseCase({required this.repository});

  final TodoRepository repository;

  Future<Result<Todo>> call({
    required String title,
    required int userId,
  }) async {
    if (title.trim().isEmpty) {
      return const Result.failure(
        ApiError(
          statusCode: 400,
          message: 'Title cannot be empty',
        ),
      );
    }

    try {
      final todo = await repository.createTodo(
        title: title.trim(),
        userId: userId,
      );
      return Result.success(todo);
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
