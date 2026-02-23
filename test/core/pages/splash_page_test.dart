import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/pages/splash_page.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('SplashPage shows loading indicator', (tester) async {
    await tester.pumpWidget(createTestApp(const SplashPage()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
