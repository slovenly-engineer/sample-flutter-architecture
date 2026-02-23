import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_flutter_architecture/features/todo/navigation/todo_routes.dart';

void main() {
  test('todoRoutes returns a list with one GoRoute', () {
    final routes = todoRoutes();

    expect(routes, isA<List<RouteBase>>());
    expect(routes.length, 1);
    expect(routes.first, isA<GoRoute>());
  });

  test('todoRoutes route has correct path', () {
    final routes = todoRoutes();
    final route = routes.first as GoRoute;

    expect(route.path, 'todos/:id');
  });
}
