import '../../../../core/network/api_result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository _repository;
  const CheckAuthUseCase(this._repository);

  ApiResult<User?> call() => _repository.getCachedUser();
}
