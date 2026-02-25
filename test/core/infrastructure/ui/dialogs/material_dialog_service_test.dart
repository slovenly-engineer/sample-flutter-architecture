import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigator_key.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/app_dialog_service.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/material_dialog_service.dart';

void main() {
  late MaterialDialogService service;

  setUp(() {
    service = MaterialDialogService();
  });

  Widget createApp({required Widget child}) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: child,
    );
  }

  group('showConfirmDialog', () {
    testWidgets('shows dialog with title, message, and buttons', (
      tester,
    ) async {
      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => service.showConfirmDialog(
                title: 'Confirm',
                message: 'Are you sure?',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('確認'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
    });

    testWidgets('returns confirmed when confirm is tapped', (tester) async {
      late ConfirmResult result;

      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await service.showConfirmDialog(
                  title: 'Title',
                  message: 'Message',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('確認'));
      await tester.pumpAndSettle();

      expect(result, ConfirmResult.confirmed);
    });

    testWidgets('returns cancelled when cancel is tapped', (tester) async {
      late ConfirmResult result;

      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await service.showConfirmDialog(
                  title: 'Title',
                  message: 'Message',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      expect(result, ConfirmResult.cancelled);
    });

    testWidgets('shows custom labels', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => service.showConfirmDialog(
                title: 'Delete',
                message: 'Delete this?',
                confirmLabel: 'Yes',
                cancelLabel: 'No',
                isDestructive: true,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });
  });

  group('showSelectionDialog', () {
    testWidgets('shows dialog with options', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => service.showSelectionDialog<String>(
                title: 'Choose',
                options: [
                  const DialogOption(label: 'Option A', value: 'a'),
                  const DialogOption(
                    label: 'Option B',
                    value: 'b',
                    isDestructive: true,
                  ),
                ],
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Choose'), findsOneWidget);
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
    });

    testWidgets('returns selected value', (tester) async {
      late String? result;

      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await service.showSelectionDialog<String>(
                  title: 'Choose',
                  options: [
                    const DialogOption(label: 'Option A', value: 'a'),
                    const DialogOption(label: 'Option B', value: 'b'),
                  ],
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle();

      expect(result, 'a');
    });
  });

  group('showSnackBar', () {
    testWidgets('shows snack bar with message', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.showSnackBar(message: 'Hello'),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('shows snack bar with action label', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.showSnackBar(
                  message: 'Undo?',
                  actionLabel: 'Undo',
                  onAction: () {},
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Undo?'), findsOneWidget);
      expect(find.byType(SnackBarAction), findsOneWidget);
    });

    testWidgets('shows snack bar with info level', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.showSnackBar(
                  message: 'Info message',
                  level: SnackBarLevel.info,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Info message'), findsOneWidget);
    });

    testWidgets('shows snack bar with error level', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.showSnackBar(
                  message: 'Error message',
                  level: SnackBarLevel.error,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('shows snack bar with success level', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.showSnackBar(
                  message: 'Success message',
                  level: SnackBarLevel.success,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Success message'), findsOneWidget);
    });

    testWidgets('shows snack bar with warning level', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => service.showSnackBar(
                  message: 'Warning message',
                  level: SnackBarLevel.warning,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Warning message'), findsOneWidget);
    });
  });

  group('showLoading / hideLoading', () {
    testWidgets('shows and hides loading dialog', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => service.showLoading(message: 'Loading...'),
              child: const Text('ShowLoading'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('ShowLoading'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);

      // Dismiss via service (dialog is non-dismissible and covers buttons)
      service.hideLoading();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading without message', (tester) async {
      await tester.pumpWidget(
        createApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => service.showLoading(),
              child: const Text('ShowLoading'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('ShowLoading'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Dismiss via service
      service.hideLoading();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
