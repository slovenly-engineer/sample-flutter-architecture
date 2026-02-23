import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ui/components/app_loading_indicator.dart';
import '../../../../core/ui/components/app_error_view.dart';
import '../../../../core/ui/components/app_empty_view.dart';
import '../providers/todo_list_provider.dart';
import 'todo_list_tile.dart';

class TodoListView extends HookConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListNotifierProvider);
    final filteredTodoList = ref.watch(filteredTodosProvider);

    return todosAsync.when(
      data: (_) {
        if (filteredTodoList.isEmpty) {
          return const AppEmptyView(
            message: 'No todos found.',
            icon: Icons.checklist,
          );
        }

        return ListView.builder(
          itemCount: filteredTodoList.length,
          itemBuilder: (context, index) {
            final todo = filteredTodoList[index];
            return TodoListTile(todo: todo);
          },
        );
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, _) => AppErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(todoListNotifierProvider),
      ),
    );
  }
}
