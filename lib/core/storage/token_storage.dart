import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  final SharedPreferences _prefs;
  const TokenStorage(this._prefs);

  Future<void> saveToken(String token) =>
      _prefs.setString(_tokenKey, token);

  String? getToken() => _prefs.getString(_tokenKey);

  bool get hasToken => _prefs.containsKey(_tokenKey);

  Future<void> saveUser({
    required int id,
    required String name,
    required String email,
  }) async {
    await _prefs.setInt(_userIdKey, id);
    await _prefs.setString(_userNameKey, name);
    await _prefs.setString(_userEmailKey, email);
  }

  int? getUserId() => _prefs.getInt(_userIdKey);
  String? getUserName() => _prefs.getString(_userNameKey);
  String? getUserEmail() => _prefs.getString(_userEmailKey);

  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
  }
}
