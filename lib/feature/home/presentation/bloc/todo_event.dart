import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTodosEvent extends TodoEvent {
  final int limit;
  final int skip;

  FetchTodosEvent({required this.limit, required this.skip});

  @override
  List<Object> get props => [limit, skip];
}

class AddTodoEvent extends TodoEvent {
  final String title;
  final bool completed;
  final int userId;


  AddTodoEvent({required this.title, required this.completed, required this.userId,});

  @override
  List<Object> get props => [title];
}

class UpdateTodoEvent extends TodoEvent {
  final int id;
  final String title;
  final bool completed;

  UpdateTodoEvent({required this.id, required this.title, required this.completed});

  @override
  List<Object> get props => [id, title, completed];
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  DeleteTodoEvent({required this.id});

  @override
  List<Object> get props => [id];
}