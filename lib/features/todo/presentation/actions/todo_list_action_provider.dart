import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/infrastructure/navigation/navigation_provider.dart';
import '../../../../core/infrastructure/ui/dialogs/dialog_provider.dart';
import '../../domain/providers/todo_providers.dart';
import '../providers/todo_list_provider.dart';
import 'todo_list_action.dart';

part 'todo_list_action_provider.g.dart';

@riverpod
TodoListAction todoListAction(Ref ref) {
  return TodoListAction(
    todoListNotifier: ref.read(todoListProvider.notifier),
    todoFilterNotifier: ref.read(todoFilterProvider.notifier),
    toggleTodoUseCase: ref.read(toggleTodoUseCaseProvider),
    createTodoUseCase: ref.read(createTodoUseCaseProvider),
    deleteTodoUseCase: ref.read(deleteTodoUseCaseProvider),
    dialogService: ref.read(dialogServiceProvider),
    navigator: ref.read(appNavigatorProvider),
  );
}
