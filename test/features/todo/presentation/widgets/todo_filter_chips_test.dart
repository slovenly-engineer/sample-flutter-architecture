import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo_filter.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_filter_chips.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_app.dart';

void main() {
  late MockTodoListAction mockAction;

  setUp(() {
    mockAction = MockTodoListAction();
  });

  setUpAll(() {
    registerFallbackValue(TodoFilter.all);
  });

  group('TodoFilterChips', () {
    testWidgets('displays all filter chips', (tester) async {
      await tester.pumpWidget(
        createTestAppWithScaffold(
          const TodoFilterChips(),
          overrides: [todoListActionProvider.overrideWith((ref) => mockAction)],
        ),
      );

      expect(find.text('ALL'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('COMPLETED'), findsOneWidget);
    });

    testWidgets('ALL chip is selected by default', (tester) async {
      await tester.pumpWidget(
        createTestAppWithScaffold(
          const TodoFilterChips(),
          overrides: [todoListActionProvider.overrideWith((ref) => mockAction)],
        ),
      );

      final allChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'ALL'),
      );
      expect(allChip.selected, isTrue);
    });

    testWidgets('tapping ACTIVE chip calls action.setFilter', (tester) async {
      await tester.pumpWidget(
        createTestAppWithScaffold(
          const TodoFilterChips(),
          overrides: [todoListActionProvider.overrideWith((ref) => mockAction)],
        ),
      );

      await tester.tap(find.text('ACTIVE'));
      await tester.pump();

      verify(() => mockAction.setFilter(TodoFilter.active)).called(1);
    });

    testWidgets('tapping COMPLETED chip calls action.setFilter', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestAppWithScaffold(
          const TodoFilterChips(),
          overrides: [todoListActionProvider.overrideWith((ref) => mockAction)],
        ),
      );

      await tester.tap(find.text('COMPLETED'));
      await tester.pump();

      verify(() => mockAction.setFilter(TodoFilter.completed)).called(1);
    });

    testWidgets('reflects externally set filter', (tester) async {
      await tester.pumpWidget(
        createTestAppWithScaffold(
          const TodoFilterChips(),
          overrides: [
            todoListActionProvider.overrideWith((ref) => mockAction),
            todoFilterProvider.overrideWith(
              () => _TestFilterNotifier(TodoFilter.completed),
            ),
          ],
        ),
      );

      final completedChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'COMPLETED'),
      );
      expect(completedChip.selected, isTrue);

      final allChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'ALL'),
      );
      expect(allChip.selected, isFalse);
    });
  });
}

class _TestFilterNotifier extends TodoFilterNotifier {
  _TestFilterNotifier(this._initial);
  final TodoFilter _initial;

  @override
  TodoFilter build() => _initial;
}
