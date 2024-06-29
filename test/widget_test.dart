import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_state.dart';
import 'package:mhust_todo/feature/home/presentation/view/widgets/todo_list_widget.dart';
import 'package:mockito/mockito.dart';

class MockTodoBloc extends Mock implements TodoBloc {}

void main() {
  late MockTodoBloc mockTodoBloc;

  setUp(() {
    mockTodoBloc = MockTodoBloc();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: BlocProvider<TodoBloc>(
        create: (_) => mockTodoBloc,
        child: Scaffold(body: widget),
      ),
    );
  }

  testWidgets('Todo list widget renders tasks correctly', (WidgetTester tester) async {
    final List<TodoEntity> mockTodos = [
      const TodoEntity(id: 1, title: 'Todo 1', completed: false, userId: 1),
      const TodoEntity(id: 2, title: 'Todo 2', completed: true, userId: 1),
    ];

    when(mockTodoBloc.state).thenReturn(TodosFetched(todos: mockTodos));


    const taskListWidget = TodoListWidget();
    await tester.pumpWidget(buildTestableWidget(taskListWidget));


    expect(find.text('Todo 1'), findsOneWidget);
    expect(find.text('Todo 2'), findsOneWidget);


    await tester.tap(find.text('Todo 1'));
    await tester.pump();


  });
}