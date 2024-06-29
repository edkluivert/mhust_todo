import 'dart:convert';
import 'package:mhust_todo/feature/home/data/datasources/todo_local_data_source.dart';
import 'package:mhust_todo/feature/home/data/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TodoModel>> getLocalTodos() async {
    final jsonString = sharedPreferences.getString('SAVED_TODOS');
    if (jsonString != null) {
      List decodedJson = json.decode(jsonString);
      return decodedJson.map<TodoModel>((json) => TodoModel.fromJson(json)).toList();
    } else {
      throw Exception('No saved todos found');
    }
  }

  @override
  Future<void> localTodos(List<TodoModel> todos) async {
    final List<Map<String, dynamic>> todoList = todos.map((todo) => todo.toJson()).toList();
    await sharedPreferences.setString('SAVED_TODOS', json.encode(todoList));
  }
}