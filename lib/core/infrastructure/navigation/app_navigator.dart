/// パッケージ非依存の画面遷移抽象インターフェース。
/// Presentation層とDomain層はこの抽象のみに依存する。
abstract class AppNavigator {
  void goToTodoDetail(String todoId);
  void goToSettings();
  void goToLogin();
  void goBack();
  void goToRoot();
}
