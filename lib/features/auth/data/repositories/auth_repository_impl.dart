import 'dart:math';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  const AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  }) async {
    final normEmail = email.trim().toLowerCase();

    // Locally-registered users (via register()) live only in local storage.
    // Re-issue a token so isLoggedIn is true after re-login.
    final cached = _local.getCachedUser();
    if (cached != null && cached.email == normEmail) {
      await _local.cacheUser(cached, _fakeToken(cached.id));
      return ApiSuccess(cached);
    }

    // Look up the DummyJSON user by email — no real password validation
    // (DummyJSON is a public read-only mock, passwords are not stored).
    final result = await _remote.findUserByEmail(normEmail);
    if (result case ApiSuccess(:final data)) {
      await _local.cacheUser(data, _fakeToken(data.id));
      return ApiSuccess(data);
    }
    return ApiFailure((result as ApiFailure).failure);
  }

  @override
  Future<ApiResult<User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normEmail = email.trim().toLowerCase();

    final cached = _local.getCachedUser();
    if (cached != null && cached.email == normEmail) {
      return const ApiFailure(AuthFailure('An account with this email already exists.'));
    }

    // Registration is local-only — DummyJSON is read-only.
    final user = UserModel(
      id: Random().nextInt(90000) + 10000,
      name: name.trim(),
      email: normEmail,
    );
    await _local.cacheUser(user, _fakeToken(user.id));
    return ApiSuccess(user);
  }

  @override
  Future<ApiResult<void>> logout() async {
    await _local.clearUser();
    return const ApiSuccess(null);
  }

  @override
  ApiResult<User?> getCachedUser() {
    if (!_local.isLoggedIn) return const ApiSuccess(null);
    final user = _local.getCachedUser();
    if (user == null) return const ApiFailure(CacheFailure('Corrupted session data.'));
    return ApiSuccess(user);
  }

  String _fakeToken(int userId) =>
      'fake_jwt_${userId}_${DateTime.now().millisecondsSinceEpoch}';
}
