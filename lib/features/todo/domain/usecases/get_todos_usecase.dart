import '../../../../core/models/api_error.dart';
import '../../../../core/models/result.dart';
import '../../models/todo.dart';
import '../../data/repositories/todo_repository.dart';

class GetTodosUseCase {
  GetTodosUseCase({required this.repository});

  final TodoRepository repository;

  Future<Result<List<Todo>>> call() async {
    try {
      final todos = await repository.getTodos();
      return Result.success(todos);
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
