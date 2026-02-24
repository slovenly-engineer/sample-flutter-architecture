import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/ui/components/app_empty_view.dart';

import '../../../helpers/test_app.dart';

void main() {
  testWidgets('AppEmptyView shows message and default icon', (tester) async {
    await tester.pumpWidget(
      createTestAppWithScaffold(const AppEmptyView(message: 'No items')),
    );

    expect(find.text('No items'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('AppEmptyView shows custom icon', (tester) async {
    await tester.pumpWidget(
      createTestAppWithScaffold(
        const AppEmptyView(message: 'Empty', icon: Icons.checklist),
      ),
    );

    expect(find.byIcon(Icons.checklist), findsOneWidget);
  });

  testWidgets('AppEmptyView shows action widget when provided', (tester) async {
    await tester.pumpWidget(
      createTestAppWithScaffold(
        AppEmptyView(
          message: 'Empty',
          action: ElevatedButton(onPressed: () {}, child: const Text('Add')),
        ),
      ),
    );

    expect(find.text('Add'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
