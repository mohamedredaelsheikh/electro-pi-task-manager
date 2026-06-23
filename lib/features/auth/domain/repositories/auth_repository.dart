import '../../../../core/network/api_result.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<User>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<ApiResult<void>> logout();

  ApiResult<User?> getCachedUser();
}
