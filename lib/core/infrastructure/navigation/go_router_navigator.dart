import 'package:go_router/go_router.dart';

import 'app_navigator.dart';

/// go_routerによる [AppNavigator] の具体実装。
/// 外部パッケージ（go_router）を直接importするのはこのクラスのみ。
class GoRouterNavigator implements AppNavigator {
  GoRouterNavigator(this._router);

  final GoRouter _router;

  @override
  void goToTodoDetail(String todoId) => _router.push('/todos/$todoId');

  @override
  void goToSettings() => _router.push('/settings');

  @override
  void goToLogin() => _router.go('/login');

  @override
  void goBack() => _router.pop();

  @override
  void goToRoot() => _router.go('/');
}
