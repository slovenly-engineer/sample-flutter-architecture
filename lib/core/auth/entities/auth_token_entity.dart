import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token_entity.freezed.dart';
part 'auth_token_entity.g.dart';

@freezed
class AuthTokenEntity with _$AuthTokenEntity {
  const factory AuthTokenEntity({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) = _AuthTokenEntity;

  factory AuthTokenEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenEntityFromJson(json);
}
