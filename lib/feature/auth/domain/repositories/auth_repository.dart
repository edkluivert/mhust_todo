import 'package:mhust_todo/feature/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String username, required String password});
  Future<UserModel> getCurrentUser();
}