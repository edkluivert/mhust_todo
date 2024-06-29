import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_local_data_source_impl.dart';
import 'package:mhust_todo/feature/home/data/datasources/todo_remote_data_source_impl.dart';
import 'package:mhust_todo/feature/home/data/models/todo_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';



class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockStorage extends Mock implements FlutterSecureStorage {}
class MockDio extends Mock implements Dio {}

void main() {

  late MockSharedPreferences mockSharedPreferences;
  late TodoLocalDataSourceImpl localDataSource;
  late MockStorage mockSecureStorage;
  const prefKey = 'SAVED_TODOS';

  late MockDio mockDio;
  late TodoRemoteDataSourceImpl remoteDataSource;

  setUp(() {

    mockSharedPreferences = MockSharedPreferences();
    mockSecureStorage = MockStorage();
    localDataSource = TodoLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);


    mockDio = MockDio();
    remoteDataSource = TodoRemoteDataSourceImpl(dio: mockDio, secureStorage: mockSecureStorage);
  });

  // Tests for TodoLocalDataSourceImpl
  group('TodoLocalDataSourceImpl', () {

    group('getLocalTodos', () {
      final List<Map<String, dynamic>> todosJson = [
        {"id": 1, "title": "Test Todo 1", "completed": false, "userId": 1},
        {"id": 2, "title": "Test Todo 2", "completed": true, "userId": 1},
      ];
      final todosString = json.encode(todosJson);

      test('should return List<TodoModel> when there are todos in sharedPreferences', () async {

        when(mockSharedPreferences.getString(prefKey)).thenReturn(todosString);


        final result = await localDataSource.getLocalTodos();


        expect(result, todosJson.map((json) => TodoModel.fromJson(json)).toList());
      });

      test('should throw an Exception when there are no todos in sharedPreferences', () async {

        when(mockSharedPreferences.getString(prefKey)).thenReturn(null);


        final call = localDataSource.getLocalTodos;


        expect(() => call(), throwsException);
      });
    });

    group('localTodos', () {
      final List<TodoModel> todos = [
        const TodoModel(id: 1, title: "Test Todo 1", completed: false, userId: 1),
        const TodoModel(id: 2, title: "Test Todo 2", completed: true, userId: 1),
      ];

      test('should call SharedPreferences to save the data', () async {
        final expectedJsonString = json.encode(todos.map((todo) => todo.toJson()).toList());

        // Print debug statement to ensure this is reached
        print('Test setup complete');
        when(mockSharedPreferences.setString(prefKey, expectedJsonString)).thenAnswer((_) async => true);

        await localDataSource.localTodos(todos);

        // Print debug statement to ensure this is reached
        print('After localTodos method call');

        // Ensure we verify setString was called once
        verify(mockSharedPreferences.setString(prefKey, expectedJsonString)).called(1);
      });
    });

  });

  // Tests for TodoRemoteDataSourceImpl
  group('TodoRemoteDataSourceImpl', () {
    group('fetchTodos', () {
      const int limit = 10;
      const int skip = 0;
      final List<Map<String, dynamic>> todosJson = [
        {"id": 1, "title": "Test Todo 1", "completed": false, "userId": 1},
        {"id": 2, "title": "Test Todo 2", "completed": true, "userId": 1},
      ];
      final responsePayload = {"todos": todosJson};

      test('should return List<TodoModel> when the response code is 200', () async {
        // Arrange
        when(mockDio.get(
          'https://reqres.in/api/todos',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
            data: responsePayload, statusCode: 200, requestOptions: RequestOptions(path: '')));

        // Act
        final result = await remoteDataSource.fetchTodos(limit, skip);

        // Assert
        expect(result, todosJson.map((json) => TodoModel.fromJson(json)).toList());
      });

      test('should throw an Exception when the response code is not 200', () async {
        // Arrange
        when(mockDio.get(
          'https://reqres.in/api/todos',
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
            data: 'Something went wrong', statusCode: 404, requestOptions: RequestOptions(path: '')));

        // Act
        final call = remoteDataSource.fetchTodos;

        // Assert
        expect(() => call(limit, skip), throwsException);
      });
    });

    group('addTodo', () {
      const String title = "New Todo";
      const bool completed = false;
      const int userId = 1;
      final Map<String, dynamic> todoJson = {"id": 1, "title": title, "completed": completed, "userId": userId};

      test('should return TodoModel when the response code is 201', () async {
        // Arrange
        when(mockDio.post(
          'https://reqres.in/api/todos',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
            data: todoJson, statusCode: 201, requestOptions: RequestOptions(path: '')));

        // Act
        final result = await remoteDataSource.addTodo(title, completed, userId, );

        // Assert
        expect(result, TodoModel.fromJson(todoJson));
      });

      test('should throw an Exception when the response code is not 201', () async {
        // Arrange
        when(mockDio.post(
          'https://reqres.in/api/todos',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
            data: 'Failed to add Todo', statusCode: 400, requestOptions: RequestOptions(path: '')));

        // Act
        final call = remoteDataSource.addTodo;

        // Assert
        expect(() => call(title, completed, userId), throwsException);
      });
    });

    group('updateTodo', () {
      const int id = 1;
      const String title = "Updated Todo";
      const bool completed = true;
      final Map<String, dynamic> updatedTodoJson = {"id": id, "title": title, "completed": completed, "userId": 1};

      test('should return TodoModel when the response code is 200', () async {
        // Arrange
        when(mockDio.put(
          'https://reqres.in/api/todos/$id',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
            data: updatedTodoJson, statusCode: 200, requestOptions: RequestOptions(path: '')));

        // Act
        final result = await remoteDataSource.updateTodo(id, completed);

        // Assert
        expect(result, TodoModel.fromJson(updatedTodoJson));
      });

      test('should throw an Exception when the response code is not 200', () async {
        // Arrange
        when(mockDio.put(
          'https://reqres.in/api/todos/$id',
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response(
            data: 'Failed to update Todo', statusCode: 400, requestOptions: RequestOptions(path: '')));

        // Act
        final call = remoteDataSource.updateTodo;

        // Assert
        expect(() => call(id, completed), throwsException);
      });
    });

    group('deleteTodo', () {
      const int id = 1;

      test('should call delete method when the response code is 200', () async {
        // Arrange
        when(mockDio.delete(
          'https://reqres.in/api/todos/$id',
        )).thenAnswer((_) async => Response(
            data: 'Deleted', statusCode: 200, requestOptions: RequestOptions(path: '')));

        // Act
        await remoteDataSource.deleteTodo(id);

        // Assert
        verify(mockDio.delete('https://reqres.in/api/todos/$id'));
      });

      test('should throw an Exception when the response code is not 200', () async {
        // Arrange
        when(mockDio.delete(
          'https://reqres.in/api/todos/$id',
        )).thenAnswer((_) async => Response(
            data: 'Failed to delete', statusCode: 400, requestOptions: RequestOptions(path: '')));

        // Act
        final call = remoteDataSource.deleteTodo;

        // Assert
        expect(() => call(id), throwsException);
      });
    });
  });
}
