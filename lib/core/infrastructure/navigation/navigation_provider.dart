import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../pages/splash_page.dart';
import '../../pages/not_found_page.dart';
import '../../../features/todo/navigation/todo_routes.dart';
import '../../../features/todo/presentation/pages/todo_list_page.dart';
import 'app_navigator.dart';
import 'go_router_navigator.dart';
import 'navigator_key.dart';

part 'navigation_provider.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Feature非依存のルート
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashPage(),
      ),

      // メインルート
      GoRoute(
        path: '/',
        builder: (_, __) => const TodoListPage(),
        routes: [
          ...todoRoutes(),
        ],
      ),
    ],
    errorBuilder: (_, __) => const NotFoundPage(),
  );
}

@riverpod
AppNavigator appNavigator(Ref ref) {
  final router = ref.watch(goRouterProvider);
  return GoRouterNavigator(router);
}
