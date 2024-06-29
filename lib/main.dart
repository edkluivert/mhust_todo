import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mhust_todo/di/service_locator.dart' as di;
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_event.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_state.dart';
import 'package:mhust_todo/feature/auth/presentation/view/login_screen.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_event.dart';
import 'package:mhust_todo/feature/home/presentation/view/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<TodoBloc>()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Mhust Todo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Lato'
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state){
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            } else if (state is AuthInitial) {
              return LoginScreen();
            } else if (state is AuthError) {
              return Scaffold(body: Center(child: Text(state.message)));
            }
            return const Scaffold(body: Center(child: CircularProgressIndicator()));

          },
        ),
      ),
    );

  }


}

