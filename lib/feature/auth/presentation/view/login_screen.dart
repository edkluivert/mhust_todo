import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_event.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              //obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  LoginEvent(
                    usernameController.text.trim(),
                    passwordController.text.trim(),
                  ),
                );
              },
              child: const Text('Login'),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthLoaded) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text('Welcome, ${state.user.firstName} ${state.user.lastName}'),
                      Image.network(state.user.image),
                    ],
                  );
                } else if (state is AuthError) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
