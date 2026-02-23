import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/ui/components/app_error_view.dart';

void main() {
  group('AppErrorView', () {
    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorView(message: 'Something went wrong'),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows Retry button when onRetry is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorView(
              message: 'Error',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('hides Retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorView(message: 'Error'),
          ),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('calls onRetry when Retry button is tapped', (tester) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorView(
              message: 'Error',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });
  });
}
