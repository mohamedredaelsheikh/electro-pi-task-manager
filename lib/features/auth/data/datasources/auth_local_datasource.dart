import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final TokenStorage _storage;
  const AuthLocalDataSource(this._storage);

  Future<void> cacheUser(UserModel user, String token) async {
    await _storage.saveToken(token);
    await _storage.saveUser(
      id: user.id,
      name: user.name,
      email: user.email,
    );
  }

  UserModel? getCachedUser() {
    final id = _storage.getUserId();
    final name = _storage.getUserName();
    final email = _storage.getUserEmail();
    if (id == null || name == null || email == null) return null;
    return UserModel(id: id, name: name, email: email);
  }

  bool get isLoggedIn => _storage.hasToken;

  Future<void> clearUser() => _storage.clearSession();
}
