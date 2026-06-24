import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/login_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/logout_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/register_usecase.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository mockRepo;

  setUp(() => mockRepo = MockAuthRepository());

  test('LoginUseCase delegates to repository', () async {
    when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const ApiSuccess(tUser));

    final result = await LoginUseCase(mockRepo)(email: 'e', password: 'p');

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.login(email: 'e', password: 'p')).called(1);
  });

  test('LoginUseCase returns failure for empty email without calling repository', () async {
    final result = await LoginUseCase(mockRepo)(email: '', password: 'pass');
    expect(result.isSuccess, isFalse);
    verifyNever(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')));
  });

  test('LoginUseCase returns failure for empty password without calling repository', () async {
    final result = await LoginUseCase(mockRepo)(email: 'a@b.com', password: '');
    expect(result.isSuccess, isFalse);
    verifyNever(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')));
  });

  test('RegisterUseCase delegates to repository', () async {
    when(() => mockRepo.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const ApiSuccess(tUser));

    final result = await RegisterUseCase(mockRepo)(
        name: 'n', email: 'e', password: 'p');

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.register(name: 'n', email: 'e', password: 'p')).called(1);
  });

  test('RegisterUseCase returns failure when any field is empty without calling repository', () async {
    final result = await RegisterUseCase(mockRepo)(name: '', email: '', password: '');
    expect(result.isSuccess, isFalse);
    verifyNever(() => mockRepo.register(name: any(named: 'name'), email: any(named: 'email'), password: any(named: 'password')));
  });

  test('LogoutUseCase delegates to repository', () async {
    when(() => mockRepo.logout()).thenAnswer((_) async => const ApiSuccess(null));

    await LogoutUseCase(mockRepo)();

    verify(() => mockRepo.logout()).called(1);
  });

  test('CheckAuthUseCase delegates to repository', () {
    when(() => mockRepo.getCachedUser()).thenReturn(const ApiSuccess(tUser));

    final result = CheckAuthUseCase(mockRepo)();

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.getCachedUser()).called(1);
  });
}
