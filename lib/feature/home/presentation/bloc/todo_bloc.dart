import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mhust_todo/feature/home/domain/usecases/todo_usecase.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_event.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoUseCase todoUseCase;

  TodoBloc({
    required this.todoUseCase,
  }) : super(TodoInitial()) {
    on<FetchTodosEvent>(_onFetchTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onFetchTodos(FetchTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await todoUseCase.fetchTodos(event.limit, event.skip);
      emit(TodosFetched(todos: todos));
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      final todo = await todoUseCase.addTodo(event.title, event.completed, event.userId);
      final currentState = state;
      if (currentState is TodosFetched) {
        emit(TodosFetched(todos: List.from(currentState.todos)..add(todo)));
      } else {
        emit(TodosFetched(todos: [todo]));
      }
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      final todo = await todoUseCase.updateTodo(event.id, event.completed);
      final currentState = state;
      if (currentState is TodosFetched) {
        emit(TodosFetched(
          todos: currentState.todos.map((t) => t.id == todo.id ? todo : t).toList(),
        ));
      }
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await todoUseCase.deleteTodo(event.id);
      final currentState = state;
      if (currentState is TodosFetched) {
        emit(TodosFetched(
          todos: currentState.todos.where((t) => t.id != event.id).toList(),
        ));
      }
    } catch (e) {
      emit(TodoError(error: e.toString()));
    }
  }
}
