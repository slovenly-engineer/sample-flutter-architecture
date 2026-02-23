import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_detail_provider.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockGetTodoDetailUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetTodoDetailUseCase();
  });

  group('todoDetailProvider', () {
    test('returns todo on success', () async {
      const todo = Todo(id: 1, userId: 1, title: 'Test');
      when(() => mockUseCase.call(1))
          .thenAnswer((_) async => const Result.success(todo));

      final container = ProviderContainer(
        overrides: [
          getTodoDetailUseCaseProvider.overrideWith((ref) => mockUseCase),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(todoDetailProvider(1).future);

      expect(result, todo);
    });

    test('throws on failure', () async {
      when(() => mockUseCase.call(1)).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 404, message: 'Not found'),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          getTodoDetailUseCaseProvider.overrideWith((ref) => mockUseCase),
        ],
      );
      addTearDown(container.dispose);

      expect(
        () => container.read(todoDetailProvider(1).future),
        throwsA(isA<Exception>()),
      );
    });

    test('provider equality based on id', () {
      final p1 = todoDetailProvider(1);
      final p2 = todoDetailProvider(1);
      final p3 = todoDetailProvider(2);

      expect(p1, equals(p2));
      expect(p1, isNot(equals(p3)));
      expect(p1.hashCode, p2.hashCode);
    });
  });
}
