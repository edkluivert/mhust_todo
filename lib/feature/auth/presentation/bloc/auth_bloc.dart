import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mhust_todo/feature/auth/data/models/user_model.dart';
import 'package:mhust_todo/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_event.dart';
import 'package:mhust_todo/feature/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCase;
  final FlutterSecureStorage secureStorage;
  UserModel? _currentUser;

  AuthBloc({required this.authUseCase, required this.secureStorage}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authUseCase.login(event.username, event.password);
        _currentUser = user;
        await secureStorage.write(key: 'user_id', value: user.id.toString());
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthGetCurrentUserEvent>((event, emit) async {
      final userId = await secureStorage.read(key: 'user_id');
      if (userId != null) {
        emit(AuthLoading());
        try {
          final user = await authUseCase.getCurrentUser();
          _currentUser = user;
          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      } else {
        emit(AuthInitial());
      }
    });
  }
}

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthUseCases authUseCase;
//   UserModel? _currentUser;
//
//   AuthBloc({required this.authUseCase}) : super(AuthInitial()) {
//     on<LoginEvent>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         final user = await authUseCase.login(event.username,  event.password);
//         _currentUser = user;
//         emit(AuthAuthenticated(user));
//       } catch (e) {
//         emit(AuthError(e.toString()));
//       }
//     });
//
//     on<AuthGetCurrentUserEvent>((event, emit) async {
//       if (_currentUser != null) {
//         emit(AuthAuthenticated( _currentUser!));
//       } else {
//         emit(AuthLoading());
//         try {
//           final user = await authUseCase.getCurrentUser();
//           _currentUser = user;
//           emit(AuthAuthenticated(user));
//         } catch (e) {
//           emit(AuthError(e.toString()));
//         }
//       }
//     });
//   }
//
//
//
// }