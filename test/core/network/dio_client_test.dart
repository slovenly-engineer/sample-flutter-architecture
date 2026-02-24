import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/network_provider.dart';

void main() {
  group('dioProvider', () {
    test('creates Dio with correct base URL', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, 'https://jsonplaceholder.typicode.com');
    });

    test('configures timeouts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    });

    test('includes LogInterceptor', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.interceptors.whereType<LogInterceptor>().length, 1);
    });
  });
}
