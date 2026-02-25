import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/todo.dart';
import '../actions/todo_list_action_provider.dart';

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
        ref.read(todoListActionProvider).removeTodo(todo.id);
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) {
            ref.read(todoListActionProvider).toggleTodo(todo);
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
        onTap: () => ref.read(todoListActionProvider).goToTodoDetail(todo.id),
      ),
    );
  }
}
