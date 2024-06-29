import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getLocalTodos();
  Future<void> localTodos(List<TodoModel> tasks);
}