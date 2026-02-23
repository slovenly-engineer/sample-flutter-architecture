import '../../../../core/models/api_error.dart';
import '../../../../core/models/result.dart';
import '../../models/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodoDetailUseCase {
  GetTodoDetailUseCase({required this.repository});

  final TodoRepository repository;

  Future<Result<Todo>> call(int id) async {
    try {
      final todo = await repository.getTodoById(id);
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
