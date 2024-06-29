import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';
import 'package:mhust_todo/feature/home/domain/usecases/todo_usecase.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_event.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_state.dart';
import 'package:mockito/mockito.dart';

class MockUseCase extends Mock implements TodoUseCase {}

void main() {
  late MockUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUseCase();
  });

  group('TodoBloc', () {
    final List<TodoEntity> mockTodos = [
      const TodoEntity(id: 1, title: 'Todo 1', completed: false, userId: 23),
      const TodoEntity(id: 2, title: 'Todo 2', completed: true, userId: 23),
    ];

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, FetchedTodos] when FetchedTodos is successful',
      build: () {
        when(mockUseCase.fetchTodos(10, 0)).thenAnswer((_) async => mockTodos);
        return TodoBloc(todoUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(FetchTodosEvent(limit: 10, skip: 0)),
      expect: () => [
        TodoLoading(),
        TodosFetched(todos: mockTodos)
      ],
      verify: (_) {
        verify(mockUseCase.fetchTodos(10, 0)).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoError] when FetchedTodos fails',
      build: () {
        when(mockUseCase.fetchTodos(10, 0)).thenThrow(Exception('Failed to fetch todos'));
        return TodoBloc(todoUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(FetchTodosEvent(limit: 10, skip: 0)),
      expect: () => [
        TodoLoading(),
        TodoError(error: 'Failed to fetch todos'),
      ],
      verify: (_) {
        verify(mockUseCase.fetchTodos(10, 0)).called(1);
      },
    );

  });
}