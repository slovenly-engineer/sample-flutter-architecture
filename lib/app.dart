import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/infrastructure/navigation/navigation_provider.dart';
import 'core/infrastructure/navigation/navigator_key.dart';
import 'core/ui/theme/app_theme.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Sample Flutter Architecture',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
