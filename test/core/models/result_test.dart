import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('creates a Success with data', () {
        const result = Result<int>.success(42);

        expect(result, isA<Success<int>>());
        expect((result as Success<int>).data, 42);
      });

      test('creates a Success with null data', () {
        const result = Result<void>.success(null);

        expect(result, isA<Success<void>>());
      });

      test('creates a Success with list data', () {
        const result = Result<List<String>>.success(['a', 'b']);

        expect(result, isA<Success<List<String>>>());
        expect((result as Success<List<String>>).data, ['a', 'b']);
      });
    });

    group('Failure', () {
      test('creates a Failure with ApiError', () {
        const error = ApiError(statusCode: 404, message: 'Not found');
        const result = Result<int>.failure(error);

        expect(result, isA<Failure<int>>());
        expect((result as Failure<int>).error.statusCode, 404);
        expect(result.error.message, 'Not found');
      });

      test('creates a Failure with detail', () {
        const error = ApiError(
          statusCode: 500,
          message: 'Server error',
          detail: 'Internal error details',
        );
        const result = Result<String>.failure(error);

        expect(result, isA<Failure<String>>());
        expect(
            (result as Failure<String>).error.detail, 'Internal error details');
      });
    });

    group('pattern matching', () {
      test('matches Success in switch', () {
        const Result<int> result = Result.success(42);

        final value = switch (result) {
          Success(:final data) => data,
          Failure(:final error) => error.statusCode,
        };

        expect(value, 42);
      });

      test('matches Failure in switch', () {
        const Result<int> result = Result.failure(
          ApiError(statusCode: 500, message: 'Error'),
        );

        final value = switch (result) {
          Success(:final data) => data,
          Failure(:final error) => error.statusCode,
        };

        expect(value, 500);
      });
    });
  });
}
