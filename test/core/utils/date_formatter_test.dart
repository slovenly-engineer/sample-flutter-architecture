import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('toYmd', () {
      test('formats date correctly', () {
        final date = DateTime(2026, 2, 8);
        expect(DateFormatter.toYmd(date), '2026-02-08');
      });

      test('pads single-digit month and day', () {
        final date = DateTime(2026, 1, 5);
        expect(DateFormatter.toYmd(date), '2026-01-05');
      });

      test('handles double-digit month and day', () {
        final date = DateTime(2026, 12, 25);
        expect(DateFormatter.toYmd(date), '2026-12-25');
      });
    });

    group('toFull', () {
      test('formats date and time correctly', () {
        final date = DateTime(2026, 2, 8, 14, 30);
        expect(DateFormatter.toFull(date), '2026-02-08 14:30');
      });

      test('pads single-digit hour and minute', () {
        final date = DateTime(2026, 2, 8, 9, 5);
        expect(DateFormatter.toFull(date), '2026-02-08 09:05');
      });
    });
  });
}
