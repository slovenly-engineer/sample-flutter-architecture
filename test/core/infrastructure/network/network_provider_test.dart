import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/dio_http_client_service.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/http_client_service.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/network_provider.dart';

void main() {
  test('dioProvider creates a Dio instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final dio = container.read(dioProvider);

    expect(dio, isA<Dio>());
  });

  test('httpClientProvider creates a DioHttpClientService', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final httpClient = container.read(httpClientProvider);

    expect(httpClient, isA<HttpClientService>());
    expect(httpClient, isA<DioHttpClientService>());
  });
}
