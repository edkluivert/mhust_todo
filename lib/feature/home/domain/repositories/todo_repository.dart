import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> fetchTodos(int limit, int skip);
  Future<TodoEntity> addTodo(String title, bool completed, int userId, int id);
  Future<TodoEntity> updateTodo(int id,  bool completed);
  Future<void> deleteTodo(int id);
}