/// パッケージ非依存のHTTPクライアント抽象インターフェース。
/// Data層（RepositoryImpl）はこの抽象のみに依存する。
abstract class HttpClientService {
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  Future<HttpResponse> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  });

  Future<HttpResponse> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  });

  Future<HttpResponse> delete(String path, {Map<String, String>? headers});

  Future<HttpResponse> upload(
    String path, {
    required String filePath,
    String fieldName = 'file',
    Map<String, String>? fields,
  });
}

/// パッケージ非依存のレスポンス型
class HttpResponse {
  const HttpResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });

  final int statusCode;
  final dynamic data;
  final Map<String, List<String>> headers;
}

/// パッケージ非依存のHTTP例外
class HttpException implements Exception {
  const HttpException({this.statusCode, required this.message, this.data});

  final int? statusCode;
  final String message;
  final dynamic data;

  @override
  String toString() => 'HttpException($statusCode): $message';
}
