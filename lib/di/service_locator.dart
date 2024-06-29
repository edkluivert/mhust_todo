import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mhust_todo/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mhust_todo/feature/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:mhust_todo/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:mhust_todo/feature/auth/domain/repositories/auth_repository.dart';
import 'package:mhust_todo/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_local_data_source.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_local_data_source_impl.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_remote_data_source.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_remote_data_source_impl.dart';
import 'package:mhust_todo/feature/home/data/repositories/todo_repository_impl.dart';
import 'package:mhust_todo/feature/home/domain/repositories/todo_repository.dart';
import 'package:mhust_todo/feature/home/domain/usecases/todo_usecase.dart';
import 'package:mhust_todo/feature/home/presentation/bloc/todo_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Package dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Data sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
        () => TodoRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<TodoLocalDataSource>(
        () => TodoLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );

  // Repositories
  sl.registerLazySingleton<TodoRepository>(
        () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => TodoUseCase(sl()));
  sl.registerLazySingleton(() => AuthUseCases(repository: sl()));

  // Blocs
  sl.registerFactory(
        () => TodoBloc(todoUseCase: sl()),
  );
  sl.registerFactory(
        () => AuthBloc(authUseCase: sl(), secureStorage: sl()),
  );
}
