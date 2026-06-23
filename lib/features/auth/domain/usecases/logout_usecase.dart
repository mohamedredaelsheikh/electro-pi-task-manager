import '../../../../core/network/api_result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<ApiResult<void>> call() => _repository.logout();
}
