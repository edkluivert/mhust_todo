import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_state.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_event.dart';

import '../../../../auth/presentation/bloc/auth_bloc.dart';

class TodoDialog extends StatefulWidget {

  const TodoDialog({super.key});

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  final TextEditingController _titleController = TextEditingController();

  int? userId;

  @override
  void initState() {
    super.initState();

    final authBloc = BlocProvider.of<AuthBloc>(context);
    final authState = authBloc.state;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;

    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(hintText: 'Enter todo title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final title = _titleController.text;
            if (title.isNotEmpty) {
              BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(title: title, completed: false, userId: userId!, ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add Todo'),
        ),
      ],
    );
  }
}
