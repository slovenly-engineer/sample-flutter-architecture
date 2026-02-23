/// 認証サービスの抽象インターフェース（横断的関心事）。
abstract class AuthService {
  Future<bool> isAuthenticated();
  Future<String?> getAccessToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Stream<bool> watchAuthState();
}
