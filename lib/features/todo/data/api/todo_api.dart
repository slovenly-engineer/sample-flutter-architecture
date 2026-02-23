import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/todo.dart';

part 'todo_api.g.dart';

@RestApi()
abstract class TodoApi {
  factory TodoApi(Dio dio, {String baseUrl}) = _TodoApi;

  @GET('/todos')
  Future<List<Todo>> getTodos();

  @GET('/todos/{id}')
  Future<Todo> getTodoById(@Path('id') int id);

  @POST('/todos')
  Future<Todo> createTodo(@Body() Map<String, dynamic> body);

  @PUT('/todos/{id}')
  Future<Todo> updateTodo(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/todos/{id}')
  Future<void> deleteTodo(@Path('id') int id);
}
