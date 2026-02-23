import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/network/dio_client.dart';

void main() {
  group('dioClientProvider', () {
    test('creates Dio with correct base URL', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioClientProvider);
      expect(dio, isA<Dio>());
      expect(
        dio.options.baseUrl,
        'https://jsonplaceholder.typicode.com',
      );
    });

    test('configures timeouts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioClientProvider);
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    });

    test('includes LogInterceptor', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioClientProvider);
      expect(
        dio.interceptors.whereType<LogInterceptor>().length,
        1,
      );
    });
  });
}
