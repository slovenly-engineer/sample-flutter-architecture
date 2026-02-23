import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/app_navigator.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/go_router_navigator.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigation_provider.dart';

void main() {
  test('goRouterProvider creates a GoRouter instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(goRouterProvider);

    expect(router, isA<GoRouter>());
  });

  test('appNavigatorProvider creates a GoRouterNavigator', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final navigator = container.read(appNavigatorProvider);

    expect(navigator, isA<AppNavigator>());
    expect(navigator, isA<GoRouterNavigator>());
  });
}
