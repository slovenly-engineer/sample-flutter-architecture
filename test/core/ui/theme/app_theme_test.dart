import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/ui/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme has correct brightness', () {
      final theme = AppTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.useMaterial3, isTrue);
    });

    test('dark theme has correct brightness', () {
      final theme = AppTheme.dark;
      expect(theme.brightness, Brightness.dark);
      expect(theme.useMaterial3, isTrue);
    });
  });
}
