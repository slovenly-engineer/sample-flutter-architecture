import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';

/// Wraps a widget with ProviderScope and MaterialApp for testing.
Widget createTestApp(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(theme: AppTheme.light, home: child),
  );
}

/// Wraps a widget with ProviderScope and MaterialApp using Scaffold.
Widget createTestAppWithScaffold(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    ),
  );
}
