import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electro_pi_task_manager/core/storage/token_storage.dart';

void main() {
  late TokenStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = TokenStorage(prefs);
  });

  group('token', () {
    test('hasToken is false when nothing saved', () {
      expect(storage.hasToken, isFalse);
    });

    test('saveToken persists and getToken retrieves it', () async {
      await storage.saveToken('my_token');
      expect(storage.getToken(), 'my_token');
      expect(storage.hasToken, isTrue);
    });
  });

  group('user', () {
    test('getUserId returns null when nothing saved', () {
      expect(storage.getUserId(), isNull);
    });

    test('saveUser persists all user fields', () async {
      await storage.saveUser(id: 5, name: 'Alice', email: 'alice@test.com');
      expect(storage.getUserId(), 5);
      expect(storage.getUserName(), 'Alice');
      expect(storage.getUserEmail(), 'alice@test.com');
    });
  });

  group('clear', () {
    test('removes token and user data', () async {
      await storage.saveToken('tok');
      await storage.saveUser(id: 1, name: 'Bob', email: 'b@t.com');
      await storage.clear();

      expect(storage.hasToken, isFalse);
      expect(storage.getUserId(), isNull);
      expect(storage.getUserName(), isNull);
      expect(storage.getUserEmail(), isNull);
    });
  });
}
