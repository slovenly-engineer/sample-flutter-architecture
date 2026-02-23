import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigator_key.dart';

void main() {
  test('rootNavigatorKey is a GlobalKey<NavigatorState>', () {
    expect(rootNavigatorKey, isA<GlobalKey<NavigatorState>>());
  });

  test('rootScaffoldMessengerKey is a GlobalKey<ScaffoldMessengerState>', () {
    expect(rootScaffoldMessengerKey, isA<GlobalKey<ScaffoldMessengerState>>());
  });
}
