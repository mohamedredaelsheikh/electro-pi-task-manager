import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/network/api_result.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;
  final CheckAuthUseCase _checkAuth;

  AuthCubit({
    required LoginUseCase login,
    required RegisterUseCase register,
    required LogoutUseCase logout,
    required CheckAuthUseCase checkAuth,
  })  : _login = login,
        _register = register,
        _logout = logout,
        _checkAuth = checkAuth,
        super(const AuthInitial());

  void checkSession() {
    final result = _checkAuth();
    switch (result) {
      case ApiSuccess(:final data) when data != null:
        emit(AuthAuthenticated(data));
      default:
        emit(const AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _login(email: email, password: password);
    switch (result) {
      case ApiSuccess(:final data):
        emit(AuthAuthenticated(data));
      case ApiFailure(:final failure):
        emit(AuthError(failure.message));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result =
        await _register(name: name, email: email, password: password);
    switch (result) {
      case ApiSuccess(:final data):
        emit(AuthAuthenticated(data));
      case ApiFailure(:final failure):
        emit(AuthError(failure.message));
    }
  }

  Future<void> logout() async {
    await _logout();
    emit(const AuthUnauthenticated());
  }
}
