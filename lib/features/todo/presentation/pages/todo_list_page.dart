import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/todo_list_provider.dart';
import '../widgets/todo_list_view.dart';
import '../widgets/todo_filter_chips.dart';
import '../widgets/todo_stats_bar.dart';
import '../widgets/add_todo_dialog.dart';

class TodoListPage extends HookConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: const Column(
        children: [
          TodoStatsBar(),
          TodoFilterChips(),
          Expanded(child: TodoListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog<String>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    ).then((title) {
      if (title != null && title.isNotEmpty) {
        ref.read(todoListNotifierProvider.notifier).addTodo(title);
      }
    });
  }
}
