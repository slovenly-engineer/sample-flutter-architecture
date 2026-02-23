import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/go_router_navigator.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockRouter;
  late GoRouterNavigator navigator;

  setUp(() {
    mockRouter = MockGoRouter();
    navigator = GoRouterNavigator(mockRouter);
  });

  test('goToTodoDetail pushes /todos/:id', () {
    when(() => mockRouter.push(any())).thenAnswer((_) async => null);

    navigator.goToTodoDetail('42');

    verify(() => mockRouter.push('/todos/42')).called(1);
  });

  test('goToSettings pushes /settings', () {
    when(() => mockRouter.push(any())).thenAnswer((_) async => null);

    navigator.goToSettings();

    verify(() => mockRouter.push('/settings')).called(1);
  });

  test('goToLogin goes to /login', () {
    when(() => mockRouter.go(any())).thenReturn(null);

    navigator.goToLogin();

    verify(() => mockRouter.go('/login')).called(1);
  });

  test('goBack pops the router', () {
    when(() => mockRouter.pop()).thenReturn(null);

    navigator.goBack();

    verify(() => mockRouter.pop()).called(1);
  });

  test('goToRoot goes to /', () {
    when(() => mockRouter.go(any())).thenReturn(null);

    navigator.goToRoot();

    verify(() => mockRouter.go('/')).called(1);
  });
}
