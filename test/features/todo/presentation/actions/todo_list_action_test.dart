import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/app_dialog_service.dart';
import 'package:sample_flutter_architecture/core/models/api_error.dart';
import 'package:sample_flutter_architecture/core/models/result.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo.dart';
import 'package:sample_flutter_architecture/features/todo/models/todo_filter.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockTodoListNotifier mockNotifier;
  late MockTodoFilterNotifier mockFilterNotifier;
  late MockToggleTodoUseCase mockToggleTodoUseCase;
  late MockCreateTodoUseCase mockCreateTodoUseCase;
  late MockDeleteTodoUseCase mockDeleteTodoUseCase;
  late MockAppDialogService mockDialogService;
  late MockAppNavigator mockNavigator;
  late TodoListAction action;

  const testTodo = Todo(id: 1, userId: 1, title: 'Test Todo');

  setUp(() {
    mockNotifier = MockTodoListNotifier();
    mockFilterNotifier = MockTodoFilterNotifier();
    mockToggleTodoUseCase = MockToggleTodoUseCase();
    mockCreateTodoUseCase = MockCreateTodoUseCase();
    mockDeleteTodoUseCase = MockDeleteTodoUseCase();
    mockDialogService = MockAppDialogService();
    mockNavigator = MockAppNavigator();

    action = TodoListAction(
      todoListNotifier: mockNotifier,
      todoFilterNotifier: mockFilterNotifier,
      toggleTodoUseCase: mockToggleTodoUseCase,
      createTodoUseCase: mockCreateTodoUseCase,
      deleteTodoUseCase: mockDeleteTodoUseCase,
      dialogService: mockDialogService,
      navigator: mockNavigator,
    );
  });

  setUpAll(() {
    registerFallbackValue(const Todo(id: 0, userId: 0, title: ''));
    registerFallbackValue(SnackBarLevel.info);
    registerFallbackValue(TodoFilter.all);
  });

  group('toggleTodo', () {
    test('updates notifier on success', () async {
      const toggledTodo = Todo(
        id: 1,
        userId: 1,
        title: 'Test Todo',
        completed: true,
      );
      when(
        () => mockToggleTodoUseCase.call(any()),
      ).thenAnswer((_) async => const Result.success(toggledTodo));

      await action.toggleTodo(testTodo);

      verify(() => mockNotifier.updateTodo(toggledTodo)).called(1);
      verifyNever(
        () => mockDialogService.showSnackBar(
          message: any(named: 'message'),
          level: any(named: 'level'),
        ),
      );
    });

    test('shows error snackbar on failure', () async {
      when(() => mockToggleTodoUseCase.call(any())).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Toggle failed'),
        ),
      );

      await action.toggleTodo(testTodo);

      verifyNever(() => mockNotifier.updateTodo(any()));
      verify(
        () => mockDialogService.showSnackBar(
          message: 'Toggle failed',
          level: SnackBarLevel.error,
        ),
      ).called(1);
    });
  });

  group('addTodo', () {
    test('prepends todo to notifier on success', () async {
      const newTodo = Todo(id: 3, userId: 1, title: 'New Todo');
      when(
        () => mockCreateTodoUseCase.call(
          title: any(named: 'title'),
          userId: any(named: 'userId'),
        ),
      ).thenAnswer((_) async => const Result.success(newTodo));

      await action.addTodo('New Todo');

      verify(() => mockNotifier.prependTodo(newTodo)).called(1);
      verifyNever(
        () => mockDialogService.showSnackBar(
          message: any(named: 'message'),
          level: any(named: 'level'),
        ),
      );
    });

    test('shows error snackbar on failure', () async {
      when(
        () => mockCreateTodoUseCase.call(
          title: any(named: 'title'),
          userId: any(named: 'userId'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Create failed'),
        ),
      );

      await action.addTodo('Fail Todo');

      verifyNever(() => mockNotifier.prependTodo(any()));
      verify(
        () => mockDialogService.showSnackBar(
          message: 'Create failed',
          level: SnackBarLevel.error,
        ),
      ).called(1);
    });
  });

  group('removeTodo', () {
    test('removes todo from notifier on success', () async {
      when(
        () => mockDeleteTodoUseCase.call(any()),
      ).thenAnswer((_) async => const Result.success(null));

      await action.removeTodo(1);

      verify(() => mockNotifier.removeTodoById(1)).called(1);
      verifyNever(
        () => mockDialogService.showSnackBar(
          message: any(named: 'message'),
          level: any(named: 'level'),
        ),
      );
    });

    test('shows error snackbar on failure', () async {
      when(() => mockDeleteTodoUseCase.call(any())).thenAnswer(
        (_) async => const Result.failure(
          ApiError(statusCode: 500, message: 'Delete failed'),
        ),
      );

      await action.removeTodo(1);

      verifyNever(() => mockNotifier.removeTodoById(any()));
      verify(
        () => mockDialogService.showSnackBar(
          message: 'Delete failed',
          level: SnackBarLevel.error,
        ),
      ).called(1);
    });
  });

  group('setFilter', () {
    test('delegates to filter notifier', () {
      action.setFilter(TodoFilter.active);

      verify(() => mockFilterNotifier.setFilter(TodoFilter.active)).called(1);
    });
  });

  group('goToTodoDetail', () {
    test('delegates to navigator', () {
      action.goToTodoDetail(42);

      verify(() => mockNavigator.goToTodoDetail('42')).called(1);
    });
  });
}
