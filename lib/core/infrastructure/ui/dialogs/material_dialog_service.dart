import 'package:flutter/material.dart';

import '../../navigation/navigator_key.dart';
import 'app_dialog_service.dart';

/// Materialによる [AppDialogService] の具体実装。
/// GlobalKeyでNavigatorState / ScaffoldMessengerStateを保持し、
/// Domain層からContextなしで呼び出せるようにする。
class MaterialDialogService implements AppDialogService {
  BuildContext get _context => rootNavigatorKey.currentContext!;
  ScaffoldMessengerState get _messenger =>
      rootScaffoldMessengerKey.currentState!;

  @override
  Future<ConfirmResult> showConfirmDialog({
    required String title,
    required String message,
    String confirmLabel = '確認',
    String cancelLabel = 'キャンセル',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: _context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result == true ? ConfirmResult.confirmed : ConfirmResult.cancelled;
  }

  @override
  Future<T?> showSelectionDialog<T>({
    required String title,
    required List<DialogOption<T>> options,
  }) async {
    return showDialog<T>(
      context: _context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: options
            .map(
              (option) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, option.value),
                child: Text(
                  option.label,
                  style: option.isDestructive
                      ? const TextStyle(color: Colors.red)
                      : null,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  void showSnackBar({
    required String message,
    SnackBarLevel level = SnackBarLevel.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _messenger.hideCurrentSnackBar();
    _messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _colorForLevel(level),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(label: actionLabel, onPressed: onAction ?? () {})
            : null,
      ),
    );
  }

  @override
  void showLoading({String? message}) {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void hideLoading() => Navigator.of(_context).pop();

  Color _colorForLevel(SnackBarLevel level) {
    return switch (level) {
      SnackBarLevel.info => Colors.grey[800]!,
      SnackBarLevel.success => Colors.green[700]!,
      SnackBarLevel.warning => Colors.orange[700]!,
      SnackBarLevel.error => Colors.red[700]!,
    };
  }
}
