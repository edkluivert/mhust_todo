import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  const TodoModel({required super.id, required super.title, required super.completed, required super.userId});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['todo'],
      completed: json['completed'],
      userId: json['userId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': title,
      'completed': completed,
      'userId' : userId
    };
  }
}