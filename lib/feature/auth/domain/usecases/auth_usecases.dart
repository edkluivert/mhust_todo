import 'package:mhust_todo/feature/auth/domain/repositories/auth_repository.dart';

import '../../data/models/user_model.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases({required this.repository});

  Future<UserModel> login(String username, String password) async {
    return await repository.login(username: username, password: password);
  }
  Future<UserModel> getCurrentUser() async {
    return await repository.getCurrentUser();
  }
}