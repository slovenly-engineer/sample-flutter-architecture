import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/pages/not_found_page.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('NotFoundPage renders correctly', (tester) async {
    await tester.pumpWidget(createTestApp(const NotFoundPage()));
    await tester.pumpAndSettle();

    expect(find.text('Not Found'), findsOneWidget);
    expect(find.text('ページが見つかりません'), findsOneWidget);
    expect(find.text('お探しのページは存在しないか、移動した可能性があります。'), findsOneWidget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);
  });
}
