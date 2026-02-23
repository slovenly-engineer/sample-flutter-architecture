/// パッケージ非依存のローカルDB抽象インターフェース。
/// Entityの定義はFeature側に配置し、このインターフェースは汎用CRUDのみ提供する。
abstract class LocalDbService {
  Future<List<T>> getAll<T>();
  Future<T?> getById<T>(int id);
  Future<int> put<T>(T entity);
  Future<List<int>> putMany<T>(List<T> entities);
  Future<bool> remove<T>(int id);
  Future<int> removeMany<T>(List<int> ids);
  Future<int> removeAll<T>();
  Future<List<T>> query<T>(Object Function() queryBuilder);
}
