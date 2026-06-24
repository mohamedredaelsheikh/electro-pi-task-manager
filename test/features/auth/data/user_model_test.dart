import 'package:flutter_test/flutter_test.dart';
import 'package:electro_pi_task_manager/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('maps id, name, email correctly', () {
      final json = {'id': 3, 'name': 'Jane Doe', 'email': 'Jane@Test.Com'};
      final model = UserModel.fromJson(json);
      expect(model.id, 3);
      expect(model.name, 'Jane Doe');
      expect(model.email, 'jane@test.com');
    });

    test('lowercases the email', () {
      final json = {'id': 1, 'name': 'A', 'email': 'UPPER@CASE.COM'};
      expect(UserModel.fromJson(json).email, 'upper@case.com');
    });
  });

  group('UserModel.toJson', () {
    test('produces a map with id, name, email', () {
      const model = UserModel(id: 7, name: 'Mo', email: 'mo@x.com');
      expect(model.toJson(), {'id': 7, 'name': 'Mo', 'email': 'mo@x.com'});
    });
  });
}
