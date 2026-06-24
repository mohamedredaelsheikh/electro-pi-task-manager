import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<ApiResult<User>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return const ApiFailure(AuthFailure('All fields are required.'));
    }
    return _repository.register(name: name, email: email, password: password);
  }
}
