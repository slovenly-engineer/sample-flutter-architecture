import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ui/theme/app_spacing.dart';
import '../../models/todo_filter.dart';
import '../providers/todo_list_provider.dart';

class TodoFilterChips extends HookConsumerWidget {
  const TodoFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(todoFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: TodoFilter.values.map((filter) {
          final isSelected = filter == currentFilter;
          return FilterChip(
            label: Text(filter.name.toUpperCase()),
            selected: isSelected,
            onSelected: (_) {
              ref.read(todoFilterProvider.notifier).setFilter(filter);
            },
          );
        }).toList(),
      ),
    );
  }
}
