import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<ApiResult<User>> call({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return const ApiFailure(AuthFailure('Email and password are required.'));
    }
    return _repository.login(email: email, password: password);
  }
}
