import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';
import 'package:mhust_todo/feature/home/domain/repositories/todo_repository.dart';

class TodoUseCase{

  final TodoRepository todoRepository;

  TodoUseCase(this.todoRepository);


  Future<List<TodoEntity>> fetchTodos(int limit, int skip) async {
    final tasks = await todoRepository.fetchTodos(limit, skip);
    return tasks;
  }


  Future<TodoEntity> addTodo(String title, bool completed, int userId, int id) async {
    final task = await todoRepository.addTodo(title, completed, userId, id);
    return task;
  }


  Future<TodoEntity> updateTodo(int id,  bool completed) async {
    final task = await todoRepository.updateTodo(id, completed);
    return task;
  }

  Future<void> deleteTodo(int id) async {
    await todoRepository.deleteTodo(id);
  }

}