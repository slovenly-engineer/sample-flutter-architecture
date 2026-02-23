import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/ui/theme/app_spacing.dart';

class AddTodoDialog extends HookConsumerWidget {
  const AddTodoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isValid = useState(false);

    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter todo title',
        ),
        onChanged: (value) {
          isValid.value = value.trim().isNotEmpty;
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.of(context).pop(value.trim());
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: AppSpacing.sm),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return FilledButton(
              onPressed: value.text.trim().isNotEmpty
                  ? () => Navigator.of(context).pop(value.text.trim())
                  : null,
              child: const Text('Add'),
            );
          },
        ),
      ],
    );
  }
}
