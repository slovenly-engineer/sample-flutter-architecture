import 'package:objectbox/objectbox.dart';

import 'local_db_service.dart';

/// ObjectBoxによる [LocalDbService] の具体実装。
/// 外部パッケージ（ObjectBox）を直接importするのはこのクラスのみ。
class ObjectBoxService implements LocalDbService {
  final Store _store;

  ObjectBoxService(this._store);

  Box<T> _box<T>() => _store.box<T>();

  @override
  Future<List<T>> getAll<T>() async => _box<T>().getAll();

  @override
  Future<T?> getById<T>(int id) async => _box<T>().get(id);

  @override
  Future<int> put<T>(T entity) async => _box<T>().put(entity);

  @override
  Future<List<int>> putMany<T>(List<T> entities) async =>
      _box<T>().putMany(entities);

  @override
  Future<bool> remove<T>(int id) async => _box<T>().remove(id);

  @override
  Future<int> removeMany<T>(List<int> ids) async => _box<T>().removeMany(ids);

  @override
  Future<int> removeAll<T>() async => _box<T>().removeAll();

  @override
  Future<List<T>> query<T>(Object Function() queryBuilder) async {
    final query = queryBuilder() as Query<T>;
    final results = query.find();
    query.close();
    return results;
  }
}
