import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_provider.dart';

/// ルートガード。認証されていない場合はログイン画面にリダイレクトする。
Future<String?> authGuard(
  BuildContext context,
  GoRouterState state,
  Ref ref,
) async {
  // 認証不要のパス
  const publicPaths = ['/splash', '/login'];
  if (publicPaths.contains(state.matchedLocation)) return null;

  final authService = ref.read(authServiceProvider);
  final isAuthenticated = await authService.isAuthenticated();
  if (!isAuthenticated) return '/login';

  return null;
}
