import 'dart:async';

import '../infrastructure/network/http_client_service.dart';
import '../infrastructure/storage/local_db_service.dart';
import 'auth_service.dart';

/// [AuthService] の具体実装。
/// Core Infrastructureの抽象のみに依存する。
class AuthServiceImpl implements AuthService {
  final LocalDbService _db;
  final HttpClientService _http;
  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  String? _cachedToken;

  AuthServiceImpl(this._db, this._http);

  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null;
  }

  @override
  Future<String?> getAccessToken() async {
    return _cachedToken;
  }

  @override
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    _authStateController.add(true);
  }

  @override
  Future<void> clearToken() async {
    _cachedToken = null;
    _authStateController.add(false);
  }

  @override
  Stream<bool> watchAuthState() => _authStateController.stream;
}
