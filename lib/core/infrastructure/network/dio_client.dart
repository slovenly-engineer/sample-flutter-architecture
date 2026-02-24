import 'package:dio/dio.dart';

/// Dioインスタンスの初期化・設定。
/// baseUrlやタイムアウト等のHTTPクライアント設定はここに閉じ込める。
Dio createDio() {
  return Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )
    ..interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
}
