import 'package:dio/dio.dart';
import 'package:mhust_todo/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mhust_todo/feature/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  @override
  Future<UserModel> login({required String username, required String password}) async {
    final response = await dio.post('https://dummyjson.com/auth/login', data: {
      'username': username,
      'password': password,
    });
    final user = UserModel.fromJson(response.data);
    await secureStorage.write(key: 'auth_token', value: user.token);
    return user;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await dio.get('https://dummyjson.com/auth/me', options: Options(headers: {
      'Authorization': 'Bearer $token',
    }));
    return UserModel.fromJson(response.data);
  }
}