import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/infrastructure/navigation/navigation_provider.dart';
import '../../models/todo.dart';
import '../providers/todo_list_provider.dart';

class TodoListTile extends HookConsumerWidget {
  const TodoListTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(todoListProvider.notifier).removeTodo(todo.id);
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) {
            ref.read(todoListProvider.notifier).toggleTodo(todo);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed
                ? Theme.of(context).colorScheme.outline
                : null,
          ),
        ),
        onTap: () =>
            ref.read(appNavigatorProvider).goToTodoDetail('${todo.id}'),
      ),
    );
  }
}
