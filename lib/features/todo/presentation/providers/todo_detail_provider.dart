import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/result.dart';
import '../../models/todo.dart';
import '../../domain/providers/todo_providers.dart';

part 'todo_detail_provider.g.dart';

@riverpod
Future<Todo> todoDetail(Ref ref, int id) async {
  final useCase = ref.watch(getTodoDetailUseCaseProvider);
  final result = await useCase(id);

  return switch (result) {
    Success(:final data) => data,
    Failure(:final error) => throw error,
  };
}
