import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_state.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_event.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_state.dart';
import 'package:mhust_todo/feature/home/presentation/view/widgets/todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    context.read<TodoBloc>().add(FetchTodosEvent(limit: 10, skip: 0));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Index'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(state.user.image),
                  );
                } else {
                  return const CircleAvatar(
                    child: Icon(Icons.person),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosFetched) {
            return state.todos.isEmpty
                ? const Center(
                    child: Text(
                        'What do you want to do today?\nTap + to add your todos'))
                : ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return Dismissible(
                  key: Key(todo.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    BlocProvider.of<TodoBloc>(context).add(DeleteTodoEvent(id: todo.id));
                  },
                  child: ListTile(
                    title: Text(todo.title),
                    trailing: Checkbox(
                      value: todo.completed,
                      onChanged: (bool? value) {
                        final updatedTodo = todo.copyWith(completed: value);
                        BlocProvider.of<TodoBloc>(context).add(
                          UpdateTodoEvent(
                            id: updatedTodo.id,
                            title: updatedTodo.title,
                            completed: updatedTodo.completed,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return const Center(child: Text('Failed to fetch todos'));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const TodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
