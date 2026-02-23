import 'package:go_router/go_router.dart';

import '../presentation/pages/todo_detail_page.dart';

/// Todo Feature固有のルート定義。
/// Featureが増えても navigation_provider.dart に1行追加するだけで済む。
List<RouteBase> todoRoutes() => [
      GoRoute(
        path: 'todos/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TodoDetailPage(todoId: id);
        },
      ),
    ];
