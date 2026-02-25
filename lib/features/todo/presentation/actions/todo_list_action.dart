import '../../../../core/infrastructure/navigation/app_navigator.dart';
import '../../../../core/infrastructure/ui/dialogs/app_dialog_service.dart';
import '../../../../core/models/result.dart';
import '../../domain/usecases/create_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../models/todo.dart';
import '../../models/todo_filter.dart';
import '../providers/todo_list_provider.dart';

/// UIイベントの司令塔。
/// UseCaseを呼びつつ、Notifier更新・Dialog表示・画面遷移を組み立てる。
/// 純粋なDartクラス（Flutter/Riverpod非依存）。
class TodoListAction {
  TodoListAction({
    required TodoListNotifier todoListNotifier,
    required TodoFilterNotifier todoFilterNotifier,
    required ToggleTodoUseCase toggleTodoUseCase,
    required CreateTodoUseCase createTodoUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
    required AppDialogService dialogService,
    required AppNavigator navigator,
  }) : _todoListNotifier = todoListNotifier,
       _todoFilterNotifier = todoFilterNotifier,
       _toggleTodoUseCase = toggleTodoUseCase,
       _createTodoUseCase = createTodoUseCase,
       _deleteTodoUseCase = deleteTodoUseCase,
       _dialogService = dialogService,
       _navigator = navigator;

  final TodoListNotifier _todoListNotifier;
  final TodoFilterNotifier _todoFilterNotifier;
  final ToggleTodoUseCase _toggleTodoUseCase;
  final CreateTodoUseCase _createTodoUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final AppDialogService _dialogService;
  final AppNavigator _navigator;

  /// Todoの完了状態をトグルする。
  Future<void> toggleTodo(Todo todo) async {
    final result = await _toggleTodoUseCase(todo);

    switch (result) {
      case Success(:final data):
        _todoListNotifier.updateTodo(data);
      case Failure(:final error):
        _dialogService.showSnackBar(
          message: error.message,
          level: SnackBarLevel.error,
        );
    }
  }

  /// 新しいTodoを追加する。
  Future<void> addTodo(String title) async {
    final result = await _createTodoUseCase(title: title, userId: 1);

    switch (result) {
      case Success(:final data):
        _todoListNotifier.prependTodo(data);
      case Failure(:final error):
        _dialogService.showSnackBar(
          message: error.message,
          level: SnackBarLevel.error,
        );
    }
  }

  /// Todoを削除する。
  Future<void> removeTodo(int id) async {
    final result = await _deleteTodoUseCase(id);

    switch (result) {
      case Success():
        _todoListNotifier.removeTodoById(id);
      case Failure(:final error):
        _dialogService.showSnackBar(
          message: error.message,
          level: SnackBarLevel.error,
        );
    }
  }

  /// フィルターを変更する。
  void setFilter(TodoFilter filter) {
    _todoFilterNotifier.setFilter(filter);
  }

  /// Todo詳細画面へ遷移する。
  void goToTodoDetail(int todoId) {
    _navigator.goToTodoDetail('$todoId');
  }
}
