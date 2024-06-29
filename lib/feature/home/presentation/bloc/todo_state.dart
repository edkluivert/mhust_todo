import 'package:equatable/equatable.dart';
import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosFetched extends TodoState {
  final List<TodoEntity> todos;

  TodosFetched({required this.todos});

  @override
  List<Object> get props => [todos];
}

class TodoError extends TodoState {
  final String error;

  TodoError({required this.error});

  @override
  List<Object> get props => [error];
}