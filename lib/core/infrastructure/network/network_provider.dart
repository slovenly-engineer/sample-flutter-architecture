import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_client.dart';
import 'dio_http_client_service.dart';
import 'http_client_service.dart';

part 'network_provider.g.dart';

@riverpod
Dio dio(Ref ref) => createDio();

@riverpod
HttpClientService httpClient(Ref ref) {
  final dioInstance = ref.watch(dioProvider);
  return DioHttpClientService(dioInstance);
}
