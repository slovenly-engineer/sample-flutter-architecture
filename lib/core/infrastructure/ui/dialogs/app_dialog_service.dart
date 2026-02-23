import 'dart:ui';

/// 確認ダイアログの結果。
enum ConfirmResult { confirmed, cancelled }

/// スナックバーの重要度レベル。
enum SnackBarLevel { info, success, warning, error }

/// 選択ダイアログの選択肢。
class DialogOption<T> {
  const DialogOption({
    required this.label,
    required this.value,
    this.isDestructive = false,
  });

  final String label;
  final T value;
  final bool isDestructive;
}

/// パッケージ非依存のダイアログ・スナックバー抽象インターフェース。
/// Domain層からBuildContextなしで呼び出せるようにする。
abstract class AppDialogService {
  Future<ConfirmResult> showConfirmDialog({
    required String title,
    required String message,
    String confirmLabel = '確認',
    String cancelLabel = 'キャンセル',
    bool isDestructive = false,
  });

  Future<T?> showSelectionDialog<T>({
    required String title,
    required List<DialogOption<T>> options,
  });

  void showSnackBar({
    required String message,
    SnackBarLevel level = SnackBarLevel.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  });

  void showLoading({String? message});
  void hideLoading();
}
