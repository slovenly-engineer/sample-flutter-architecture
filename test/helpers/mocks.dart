import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/core/infrastructure/navigation/app_navigator.dart';
import 'package:sample_flutter_architecture/core/infrastructure/network/http_client_service.dart';
import 'package:sample_flutter_architecture/core/infrastructure/storage/local_db_service.dart';
import 'package:sample_flutter_architecture/core/infrastructure/ui/dialogs/app_dialog_service.dart';
import 'package:sample_flutter_architecture/features/todo/domain/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/create_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todo_detail_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/toggle_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/actions/todo_list_action.dart';
import 'package:sample_flutter_architecture/features/todo/presentation/providers/todo_list_provider.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class MockHttpClientService extends Mock implements HttpClientService {}

class MockLocalDbService extends Mock implements LocalDbService {}

class MockAppNavigator extends Mock implements AppNavigator {}

class MockAppDialogService extends Mock implements AppDialogService {}

class MockGetTodosUseCase extends Mock implements GetTodosUseCase {}

class MockGetTodoDetailUseCase extends Mock implements GetTodoDetailUseCase {}

class MockToggleTodoUseCase extends Mock implements ToggleTodoUseCase {}

class MockCreateTodoUseCase extends Mock implements CreateTodoUseCase {}

class MockDeleteTodoUseCase extends Mock implements DeleteTodoUseCase {}

class MockTodoListAction extends Mock implements TodoListAction {}

class MockTodoListNotifier extends Mock implements TodoListNotifier {}

class MockTodoFilterNotifier extends Mock implements TodoFilterNotifier {}
