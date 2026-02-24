import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';

void main() {
  group('ApiError', () {
    test('creates with required fields', () {
      const error = ApiError(statusCode: 404, message: 'Not found');

      expect(error.statusCode, 404);
      expect(error.message, 'Not found');
      expect(error.detail, isNull);
    });

    test('creates with optional detail', () {
      const error = ApiError(
        statusCode: 500,
        message: 'Server error',
        detail: 'Stack trace here',
      );

      expect(error.statusCode, 500);
      expect(error.message, 'Server error');
      expect(error.detail, 'Stack trace here');
    });

    test('fromJson creates correct instance', () {
      final json = {
        'statusCode': 400,
        'message': 'Bad request',
        'detail': 'Invalid input',
      };

      final error = ApiError.fromJson(json);

      expect(error.statusCode, 400);
      expect(error.message, 'Bad request');
      expect(error.detail, 'Invalid input');
    });

    test('fromJson handles null detail', () {
      final json = {'statusCode': 404, 'message': 'Not found'};

      final error = ApiError.fromJson(json);

      expect(error.statusCode, 404);
      expect(error.message, 'Not found');
      expect(error.detail, isNull);
    });

    test('toJson roundtrip', () {
      const original = ApiError(
        statusCode: 422,
        message: 'Validation error',
        detail: 'Field required',
      );

      final json = original.toJson();
      final restored = ApiError.fromJson(json);

      expect(restored, equals(original));
    });

    test('equality works correctly', () {
      const error1 = ApiError(statusCode: 500, message: 'Error');
      const error2 = ApiError(statusCode: 500, message: 'Error');
      const error3 = ApiError(statusCode: 404, message: 'Not found');

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });
  });
}
