import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_provider.dart';
import '../infrastructure/storage/objectbox_provider.dart';
import 'app_initializer.dart';

part 'app_initializer_provider.g.dart';

@riverpod
AppInitializer appInitializer(Ref ref) {
  return AppInitializer(
    ref.watch(localDbServiceProvider),
    ref.watch(authServiceProvider),
  );
}
