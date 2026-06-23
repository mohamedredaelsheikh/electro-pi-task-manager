import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final TokenStorage _storage;
  const ProfileRepositoryImpl(this._storage);

  @override
  ApiResult<User> getProfile() {
    final id = _storage.getUserId();
    final name = _storage.getUserName();
    final email = _storage.getUserEmail();

    if (id == null || name == null || email == null) {
      return const ApiFailure(CacheFailure('Profile not found in local storage.'));
    }
    return ApiSuccess(User(id: id, name: name, email: email));
  }
}
