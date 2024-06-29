import 'package:mhust_todo/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mhust_todo/feature/auth/data/models/user_model.dart';
import 'package:mhust_todo/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});


  @override
  Future<UserModel> login({required String username, required String password}) async {
    return await remoteDataSource.login(username: username, password: password);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
}