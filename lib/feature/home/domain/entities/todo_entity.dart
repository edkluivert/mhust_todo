
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final bool completed;
  final int userId;

  const TodoEntity({required this.id, required this.title, required this.completed, required this.userId});

  @override
  List<Object> get props => [id, title, completed, userId];

  TodoEntity copyWith({
    int? id,
    String? title,
    bool? completed,
    int? userId
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
