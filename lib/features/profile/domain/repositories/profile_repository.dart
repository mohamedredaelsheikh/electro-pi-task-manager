import '../../../../core/network/api_result.dart';
import '../../../auth/domain/entities/user.dart';

abstract interface class ProfileRepository {
  ApiResult<User> getProfile();
}
