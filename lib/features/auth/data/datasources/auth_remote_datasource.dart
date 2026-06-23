import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/user_model.dart';

/// JSONPlaceholder has no real auth endpoint. We fetch /users filtered by email
/// and treat a match as a successful login. Password is not validated server-side
/// (JSONPlaceholder is a read-only mock). Registration is entirely local.
class AuthRemoteDataSource {
  final ApiClient _client;
  const AuthRemoteDataSource(this._client);

  Future<ApiResult<UserModel>> findUserByEmail(String email) async {
    final result = await _client.get<List<UserModel>>(
      ApiConstants.users,
      queryParameters: {'email': email},
      fromJson: (data) => (data as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return switch (result) {
      ApiSuccess(:final data) when data.isNotEmpty => ApiSuccess(data.first),
      ApiSuccess() =>
        const ApiFailure(AuthFailure('No account found with that email.')),
      ApiFailure(:final failure) => ApiFailure(failure),
    };
  }
}
