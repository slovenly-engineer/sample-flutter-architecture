import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/add_todo_dialog.dart';

void main() {
  Widget createApp() {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (_) => const AddTodoDialog(),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(createApp());
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  group('AddTodoDialog', () {
    testWidgets('displays title, TextField, Cancel, and Add buttons', (
      tester,
    ) async {
      await openDialog(tester);

      expect(find.text('Add Todo'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('Add button is disabled when input is empty', (tester) async {
      await openDialog(tester);

      final addButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Add'),
      );
      expect(addButton.onPressed, isNull);
    });

    testWidgets('Add button is enabled when text is entered', (tester) async {
      await openDialog(tester);

      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.pump();

      final addButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Add'),
      );
      expect(addButton.onPressed, isNotNull);
    });

    testWidgets('Add button is disabled for whitespace-only input', (
      tester,
    ) async {
      await openDialog(tester);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      final addButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Add'),
      );
      expect(addButton.onPressed, isNull);
    });

    testWidgets('Cancel closes the dialog', (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Add button closes dialog', (tester) async {
      await openDialog(tester);

      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.pump();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('submitting via Enter key closes dialog', (tester) async {
      await openDialog(tester);

      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
