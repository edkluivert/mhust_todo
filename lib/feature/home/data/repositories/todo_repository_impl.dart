import 'package:mhust_todo/feature/home/data/datasources/todo_local_data_source.dart';
import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';
import 'package:mhust_todo/feature/home/domain/repositories/todo_repository.dart';

import '../datasources/todo_remote_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<TodoEntity>> fetchTodos(int limit, int skip) async {
    try {
      final List<TodoEntity> remoteTodos = await remoteDataSource.fetchTodos(limit, skip);
      final List<TodoEntity> localTodos = await localDataSource.getLocalTodos();


      final List<TodoEntity> mergedTodos = [];


      mergedTodos.addAll(remoteTodos);

      for (final localTodo in localTodos) {
        if (!remoteTodos.any((remoteTodo) => remoteTodo.id == localTodo.id)) {
          mergedTodos.add(localTodo);
        }
      }
      print(mergedTodos);
      return mergedTodos;
    } catch (e) {
      //fallback to local todos
      final localTodos = await localDataSource.getLocalTodos();
      return localTodos;
    }
  }


  @override
  Future<TodoEntity> addTodo(String title, bool completed, int userId) async {
    final todo = await remoteDataSource.addTodo(title,completed,userId);
    final localTodos = await localDataSource.getLocalTodos();
    localDataSource.localTodos([...localTodos, todo]);
    return todo;
  }

  @override
  Future<TodoEntity> updateTodo(int id,  bool completed) async {
    final todo = await remoteDataSource.updateTodo(id, completed);
    final localTodos = await localDataSource.getLocalTodos();
    final updatedTodos = localTodos.map((t) => t.id == id ? todo : t).toList();
    localDataSource.localTodos(updatedTodos);
    return todo;
  }

  @override
  Future<void> deleteTodo(int id) async {
    await remoteDataSource.deleteTodo(id);
    final localTodos = await localDataSource.getLocalTodos();
    final updatedTodos = localTodos.where((t) => t.id != id).toList();
    localDataSource.localTodos(updatedTodos);
  }
}