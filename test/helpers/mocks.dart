import 'package:mocktail/mocktail.dart';
import 'package:sample_flutter_architecture/features/todo/data/api/todo_api.dart';
import 'package:sample_flutter_architecture/features/todo/data/repositories/todo_repository.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/create_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todo_detail_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:sample_flutter_architecture/features/todo/domain/usecases/toggle_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class MockTodoApi extends Mock implements TodoApi {}

class MockGetTodosUseCase extends Mock implements GetTodosUseCase {}

class MockGetTodoDetailUseCase extends Mock implements GetTodoDetailUseCase {}

class MockToggleTodoUseCase extends Mock implements ToggleTodoUseCase {}

class MockCreateTodoUseCase extends Mock implements CreateTodoUseCase {}

class MockDeleteTodoUseCase extends Mock implements DeleteTodoUseCase {}
