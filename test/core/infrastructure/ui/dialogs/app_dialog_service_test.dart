import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/app_dialog_service.dart';

void main() {
  group('ConfirmResult', () {
    test('has confirmed and cancelled values', () {
      expect(ConfirmResult.values.length, 2);
      expect(ConfirmResult.confirmed, isNotNull);
      expect(ConfirmResult.cancelled, isNotNull);
    });
  });

  group('SnackBarLevel', () {
    test('has all level values', () {
      expect(SnackBarLevel.values.length, 4);
      expect(SnackBarLevel.info, isNotNull);
      expect(SnackBarLevel.success, isNotNull);
      expect(SnackBarLevel.warning, isNotNull);
      expect(SnackBarLevel.error, isNotNull);
    });
  });

  group('DialogOption', () {
    test('creates with required fields', () {
      const option = DialogOption<String>(label: 'OK', value: 'ok');

      expect(option.label, 'OK');
      expect(option.value, 'ok');
      expect(option.isDestructive, false);
    });

    test('creates with isDestructive', () {
      const option = DialogOption<int>(
        label: 'Delete',
        value: 1,
        isDestructive: true,
      );

      expect(option.isDestructive, true);
    });
  });
}
