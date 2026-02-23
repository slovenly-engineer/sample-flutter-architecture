import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_db_service.dart';
import 'objectbox_service.dart';

part 'objectbox_provider.g.dart';

/// ObjectBox Storeインスタンス。
/// main.dartで初期化したインスタンスをoverrideで渡す。
@riverpod
Store objectBoxStore(Ref ref) => throw UnimplementedError(
      'objectBoxStoreProvider must be overridden with a Store instance',
    );

@riverpod
LocalDbService localDbService(Ref ref) {
  final store = ref.watch(objectBoxStoreProvider);
  return ObjectBoxService(store);
}
