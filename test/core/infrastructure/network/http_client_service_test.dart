import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/http_client_service.dart';

void main() {
  group('HttpResponse', () {
    test('creates with required fields', () {
      const response = HttpResponse(statusCode: 200, data: 'test');

      expect(response.statusCode, 200);
      expect(response.data, 'test');
      expect(response.headers, const <String, List<String>>{});
    });

    test('creates with headers', () {
      const response = HttpResponse(
        statusCode: 200,
        data: null,
        headers: {
          'content-type': ['application/json']
        },
      );

      expect(response.headers['content-type'], ['application/json']);
    });
  });

  group('HttpException', () {
    test('creates with required message', () {
      const exception = HttpException(message: 'error');

      expect(exception.message, 'error');
      expect(exception.statusCode, isNull);
      expect(exception.data, isNull);
    });

    test('creates with all fields', () {
      const exception = HttpException(
        statusCode: 404,
        message: 'Not found',
        data: 'details',
      );

      expect(exception.statusCode, 404);
      expect(exception.message, 'Not found');
      expect(exception.data, 'details');
    });

    test('toString returns formatted string', () {
      const exception = HttpException(statusCode: 500, message: 'Server error');

      expect(exception.toString(), 'HttpException(500): Server error');
    });

    test('toString with null statusCode', () {
      const exception = HttpException(message: 'Unknown');

      expect(exception.toString(), 'HttpException(null): Unknown');
    });
  });
}
