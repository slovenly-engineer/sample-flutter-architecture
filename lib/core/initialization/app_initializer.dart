import '../auth/auth_service.dart';
import '../infrastructure/storage/local_db_service.dart';

/// アプリ起動時の初期化処理を集約するクラス。
class AppInitializer {
  AppInitializer(this._db, this._auth);

  // ignore: unused_field
  final LocalDbService _db;
  // ignore: unused_field
  final AuthService _auth;

  Future<void> execute() async {
    // DB初期化、認証状態確認、設定読み込み等
    // 必要に応じてここに初期化処理を追加
  }
}
