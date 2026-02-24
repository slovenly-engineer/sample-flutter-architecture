import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/dio_http_client_service.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/http_client_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DioHttpClientService service;

  setUp(() {
    mockDio = MockDio();
    service = DioHttpClientService(mockDio);
  });

  setUpAll(() {
    registerFallbackValue(Options());
  });

  Response<dynamic> createResponse({
    int statusCode = 200,
    dynamic data,
    Map<String, List<String>> headers = const {},
  }) {
    return Response(
      statusCode: statusCode,
      data: data,
      headers: Headers.fromMap(headers),
      requestOptions: RequestOptions(path: '/test'),
    );
  }

  DioException createDioException({
    int? statusCode,
    String? message,
    dynamic data,
  }) {
    return DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: statusCode != null
          ? Response(
              statusCode: statusCode,
              data: data,
              requestOptions: RequestOptions(path: '/test'),
            )
          : null,
      message: message,
    );
  }

  group('get', () {
    test('returns HttpResponse on success', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => createResponse(statusCode: 200, data: {'key': 'value'}),
      );

      final result = await service.get('/test');

      expect(result.statusCode, 200);
      expect(result.data, {'key': 'value'});
    });

    test('passes query parameters', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => createResponse(statusCode: 200, data: null));

      await service.get('/test', queryParameters: {'q': 'search'});

      verify(
        () => mockDio.get(
          '/test',
          queryParameters: {'q': 'search'},
          options: null,
        ),
      ).called(1);
    });

    test('passes headers via Options', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => createResponse(statusCode: 200, data: null));

      await service.get('/test', headers: {'Authorization': 'Bearer token'});

      verify(
        () => mockDio.get(
          '/test',
          queryParameters: null,
          options: any(named: 'options', that: isA<Options>()),
        ),
      ).called(1);
    });

    test('throws HttpException on DioException', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(createDioException(statusCode: 404, message: 'Not found'));

      expect(
        () => service.get('/test'),
        throwsA(
          isA<HttpException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.message, 'message', 'Not found'),
        ),
      );
    });
  });

  group('post', () {
    test('returns HttpResponse on success', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => createResponse(statusCode: 201, data: {'id': 1}),
      );

      final result = await service.post('/test', body: {'title': 'new'});

      expect(result.statusCode, 201);
      expect(result.data, {'id': 1});
    });

    test('throws HttpException on DioException', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(createDioException(statusCode: 500, message: 'Error'));

      expect(
        () => service.post('/test', body: {}),
        throwsA(isA<HttpException>()),
      );
    });
  });

  group('put', () {
    test('returns HttpResponse on success', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => createResponse(statusCode: 200, data: {'updated': true}),
      );

      final result = await service.put('/test', body: {'title': 'updated'});

      expect(result.statusCode, 200);
    });

    test('throws HttpException on DioException', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(createDioException(statusCode: 500, message: 'Error'));

      expect(
        () => service.put('/test', body: {}),
        throwsA(isA<HttpException>()),
      );
    });
  });

  group('delete', () {
    test('returns HttpResponse on success', () async {
      when(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).thenAnswer((_) async => createResponse(statusCode: 204, data: null));

      final result = await service.delete('/test');

      expect(result.statusCode, 204);
    });

    test('passes headers', () async {
      when(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).thenAnswer((_) async => createResponse(statusCode: 200, data: null));

      await service.delete('/test', headers: {'X-Custom': 'value'});

      verify(
        () => mockDio.delete(
          '/test',
          options: any(named: 'options', that: isA<Options>()),
        ),
      ).called(1);
    });

    test('throws HttpException on DioException', () async {
      when(
        () => mockDio.delete(any(), options: any(named: 'options')),
      ).thenThrow(createDioException(statusCode: 500, message: 'Error'));

      expect(() => service.delete('/test'), throwsA(isA<HttpException>()));
    });
  });

  group('post with headers', () {
    test('passes headers via Options', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => createResponse(statusCode: 200, data: null));

      await service.post(
        '/test',
        body: {'a': 1},
        headers: {'Authorization': 'Bearer token'},
      );

      verify(
        () => mockDio.post(
          '/test',
          data: {'a': 1},
          options: any(named: 'options', that: isA<Options>()),
        ),
      ).called(1);
    });
  });

  group('put with headers', () {
    test('passes headers via Options', () async {
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => createResponse(statusCode: 200, data: null));

      await service.put(
        '/test',
        body: {'a': 1},
        headers: {'Authorization': 'Bearer token'},
      );

      verify(
        () => mockDio.put(
          '/test',
          data: {'a': 1},
          options: any(named: 'options', that: isA<Options>()),
        ),
      ).called(1);
    });
  });

  group('upload', () {
    test('throws HttpException on DioException', () async {
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(createDioException(statusCode: 500, message: 'Error'));

      expect(
        () => service.upload('/upload', filePath: '/nonexistent/file.txt'),
        throwsA(anything),
      );
    });
  });

  group('_toException edge cases', () {
    test('handles null message in DioException', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          message: null,
        ),
      );

      expect(
        () => service.get('/test'),
        throwsA(
          isA<HttpException>()
              .having((e) => e.message, 'message', 'Unknown error')
              .having((e) => e.statusCode, 'statusCode', isNull),
        ),
      );
    });

    test('handles null statusCode in response', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          statusCode: null,
          data: 'data',
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      final result = await service.get('/test');
      expect(result.statusCode, 0);
    });
  });
}
