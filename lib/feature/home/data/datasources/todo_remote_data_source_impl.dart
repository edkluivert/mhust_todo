import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_remote_data_source.dart';
import 'package:mhust_todo/feature/home/data/models/todo_model.dart';

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final Dio dio;

  final FlutterSecureStorage secureStorage;
  TodoRemoteDataSourceImpl( {required this.dio, required this.secureStorage});

  @override
  Future<List<TodoModel>> fetchTodos(int limit, int skip) async {
    final id = await secureStorage.read(key: 'user_id');
    final response = await dio.get('https://dummyjson.com/todos/user/$id?limit=$limit&skip=$skip');
    if (response.statusCode == 200) {
      return (response.data['todos'] as List)
          .map((json) => TodoModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Error occurred in getting Todos');
    }
  }

  @override
  Future<TodoModel> addTodo(String title, bool completed, int userId, int id) async {
    final response = await dio.post('https://dummyjson.com/todos/add',
        data: {'todo': title, 'completed':completed,
    'userId' : userId, });
    if (response.statusCode == 201) {
      return TodoModel.fromJson(response.data);
    } else {
      throw Exception('Failed to add Todo');
    }
  }

  @override
  Future<TodoModel> updateTodo(int id, bool completed) async {
    final response = await dio.put('https://dummyjson.com/todos/$id', data: { 'completed': completed});
    if (response.statusCode == 200) {
      return TodoModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update Todo');
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    final response = await dio.delete('https://dummyjson.com/todos/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Todo');
    }
  }
}