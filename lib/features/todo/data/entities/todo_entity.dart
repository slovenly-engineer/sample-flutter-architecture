import '../../models/todo.dart';

/// TodoのDB Entity定義（Feature側に配置）。
/// Model ↔ Entity変換メソッドを持つ。
class TodoEntity {
  TodoEntity({
    this.id = 0,
    required this.userId,
    required this.title,
    this.completed = false,
  });

  factory TodoEntity.fromModel(Todo todo) => TodoEntity(
    id: todo.id,
    userId: todo.userId,
    title: todo.title,
    completed: todo.completed,
  );

  int id;
  int userId;
  String title;
  bool completed;

  Todo toModel() =>
      Todo(id: id, userId: userId, title: title, completed: completed);
}
