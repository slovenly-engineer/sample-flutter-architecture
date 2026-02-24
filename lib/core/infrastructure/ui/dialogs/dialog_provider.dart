import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_dialog_service.dart';
import 'material_dialog_service.dart';

part 'dialog_provider.g.dart';

@riverpod
AppDialogService dialogService(Ref ref) {
  return MaterialDialogService();
}
