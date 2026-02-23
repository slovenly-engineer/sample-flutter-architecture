import 'package:flutter/material.dart';

import '../ui/theme/app_spacing.dart';

/// 404ページ（Feature非依存）。
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'ページが見つかりません',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'お探しのページは存在しないか、移動した可能性があります。',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
