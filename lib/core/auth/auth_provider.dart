import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../infrastructure/network/network_provider.dart';
import '../infrastructure/storage/objectbox_provider.dart';
import 'auth_service.dart';
import 'auth_service_impl.dart';

part 'auth_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthServiceImpl(
    ref.watch(localDbServiceProvider),
    ref.watch(httpClientProvider),
  );
}
