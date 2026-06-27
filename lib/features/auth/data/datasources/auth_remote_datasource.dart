import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _client;
  const AuthRemoteDataSource(this._client);

  // DummyJSON /users/filter?key=email&value=... returns { users: [...] }
  Future<ApiResult<UserModel>> findUserByEmail(String email) async {
    final result = await _client.get<UserModel?>(
      '${ApiConstants.users}/filter',
      queryParameters: {
        'key': 'email',
        'value': email,
        'select': 'id,firstName,lastName,email',
      },
      fromJson: (data) {
        final users = ((data as Map<String, dynamic>)['users'] as List)
            .cast<Map<String, dynamic>>();
        if (users.isEmpty) return null;
        final u = users.first;
        return UserModel(
          id: u['id'] as int,
          name: '${u['firstName']} ${u['lastName']}'.trim(),
          email: u['email'] as String,
        );
      },
    );
    return switch (result) {
      ApiSuccess(:final data) when data != null => ApiSuccess(data),
      ApiSuccess() =>
        const ApiFailure(AuthFailure('No account found with that email.')),
      ApiFailure(:final failure) => ApiFailure(failure),
    };
  }
}
