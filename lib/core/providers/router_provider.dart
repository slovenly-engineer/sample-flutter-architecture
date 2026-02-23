import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/todo/presentation/pages/todo_list_page.dart';
import '../../features/todo/presentation/pages/todo_detail_page.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'todoList',
        builder: (context, state) => const TodoListPage(),
      ),
      GoRoute(
        path: '/todo/:id',
        name: 'todoDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TodoDetailPage(todoId: id);
        },
      ),
    ],
  );
}
