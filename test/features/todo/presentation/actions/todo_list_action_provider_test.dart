import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/navigation_provider.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/network_provider.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/dialog_provider.dart';
import 'package:sample_flutter_architecture/features/todo/domain/providers/todo_providers.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action_provider.dart';

import '../../../../helpers/mocks.dart';

void main() {
  group('todoListActionProvider', () {
    test('creates a TodoListAction instance', () {
      final mockRepository = MockTodoRepository();
      final mockHttpClient = MockHttpClientService();
      final mockNavigator = MockAppNavigator();
      final mockDialogService = MockAppDialogService();

      when(() => mockRepository.getTodos()).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          todoRepositoryProvider.overrideWith((ref) => mockRepository),
          httpClientProvider.overrideWith((ref) => mockHttpClient),
          appNavigatorProvider.overrideWith((ref) => mockNavigator),
          dialogServiceProvider.overrideWith((ref) => mockDialogService),
        ],
      );
      addTearDown(container.dispose);

      final action = container.read(todoListActionProvider);
      expect(action, isA<TodoListAction>());
    });
  });
}
