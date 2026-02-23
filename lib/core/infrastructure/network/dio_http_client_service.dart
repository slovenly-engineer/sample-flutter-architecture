import 'package:dio/dio.dart';

import 'http_client_service.dart';

/// Dioによる [HttpClientService] の具体実装。
/// 外部パッケージ（Dio）を直接importするのはこのクラスのみ。
class DioHttpClientService implements HttpClientService {
  DioHttpClientService(this._dio);

  final Dio _dio;

  @override
  Future<HttpResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<HttpResponse> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<HttpResponse> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<HttpResponse> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        options: headers != null ? Options(headers: headers) : null,
      );
      return _toResponse(response);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<HttpResponse> upload(
    String path, {
    required String filePath,
    String fieldName = 'file',
    Map<String, String>? fields,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?fields,
      });
      final response = await _dio.post(path, data: formData);
      return _toResponse(response);
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  HttpResponse _toResponse(Response response) {
    return HttpResponse(
      statusCode: response.statusCode ?? 0,
      data: response.data,
      headers: response.headers.map,
    );
  }

  HttpException _toException(DioException e) {
    return HttpException(
      statusCode: e.response?.statusCode,
      message: e.message ?? 'Unknown error',
      data: e.response?.data,
    );
  }
}
