import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/dialog_provider.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/material_dialog_service.dart';

void main() {
  test('dialogServiceProvider returns MaterialDialogService', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final service = container.read(dialogServiceProvider);
    expect(service, isA<MaterialDialogService>());
  });
}
