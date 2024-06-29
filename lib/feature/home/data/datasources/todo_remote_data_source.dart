import 'package:mhust_todo/feature/home/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> fetchTodos(int limit, int skip);
  Future<TodoModel> addTodo(String title, bool completed, int userId, int id);
  Future<TodoModel> updateTodo(int id,bool completed);
  Future<void> deleteTodo(int id);
}