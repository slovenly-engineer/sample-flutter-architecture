import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_error.dart';

part 'result.freezed.dart';

/// A generic result type for handling success/failure in a type-safe manner.
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(ApiError error) = Failure<T>;
}
