import 'package:flutter_test/flutter_test.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/widgets/todo_stats_bar.dart';

import '../../../../helpers/test_app.dart';

void main() {
  group('TodoStatsBar', () {
    testWidgets('displays correct stats values', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const TodoStatsBar(),
          overrides: [
            todoStatsProvider.overrideWith(
              (ref) => const TodoStats(total: 10, completed: 6, active: 4),
            ),
          ],
        ),
      );

      expect(find.text('10'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('displays zero values', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const TodoStatsBar(),
          overrides: [
            todoStatsProvider.overrideWith(
              (ref) => const TodoStats(total: 0, completed: 0, active: 0),
            ),
          ],
        ),
      );

      expect(find.text('0'), findsNWidgets(3));
    });
  });
}
