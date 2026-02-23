import '../../../../core/models/api_error.dart';
import '../../../../core/models/result.dart';
import '../../data/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  DeleteTodoUseCase({required this.repository});

  final TodoRepository repository;

  Future<Result<void>> call(int id) async {
    try {
      await repository.deleteTodo(id);
      return const Result.success(null);
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
