import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_state.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodosFetched) {
          final todos = state.todos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                key: Key('todo_item_${todo.id}'),
                title: Text(todo.title),
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: (bool? value) {
                    // Handle checkbox change if needed
                  },
                ),
                onTap: () {
                  // Handle onTap if needed
                },
              );
            },
          );
        } else if (state is TodoError) {
          return const Center(child: Text('Failed to fetch todos'));
        }
        return Container();
      },
    );
  }
}
