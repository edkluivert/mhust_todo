import 'package:equatable/equatable.dart';
import 'package:mhust_todo/feature/auth/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final UserModel user;

  AuthLoaded(this.user);

  @override
  List<Object> get props => [user];
}
class AuthAuthenticated extends AuthState {
  final UserModel user;

  AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}