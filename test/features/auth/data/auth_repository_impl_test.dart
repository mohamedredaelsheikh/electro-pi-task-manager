import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/auth/data/models/user_model.dart';
import 'package:electro_pi_task_manager/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late AuthRepositoryImpl repo;
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    repo = AuthRepositoryImpl(mockRemote, mockLocal);
    registerFallbackValue(tUserModel);
  });

  group('login', () {
    test('returns ApiSuccess and caches user on remote success', () async {
      when(() => mockRemote.findUserByEmail(any()))
          .thenAnswer((_) async => const ApiSuccess(tUserModel));
      when(() => mockLocal.cacheUser(any(), any()))
          .thenAnswer((_) async {});

      final result = await repo.login(email: 'john@example.com', password: 'pass');

      expect(result.isSuccess, isTrue);
      expect(result.data, tUser);
      verify(() => mockLocal.cacheUser(any(), any())).called(1);
    });

    test('returns ApiFailure when remote fails', () async {
      when(() => mockRemote.findUserByEmail(any()))
          .thenAnswer((_) async => const ApiFailure(AuthFailure('Not found')));

      final result = await repo.login(email: 'x@x.com', password: 'pass');

      expect(result.isSuccess, isFalse);
      verifyNever(() => mockLocal.cacheUser(any(), any()));
    });

  });

  group('register', () {
    test('caches new user and returns ApiSuccess', () async {
      when(() => mockLocal.getCachedUser()).thenReturn(null);
      when(() => mockLocal.cacheUser(any(), any())).thenAnswer((_) async {});

      final result = await repo.register(
        name: 'New User',
        email: 'new@test.com',
        password: 'password',
      );

      expect(result.isSuccess, isTrue);
      final user = result.data;
      expect(user.id, greaterThanOrEqualTo(10000));
      expect(user.name, 'New User');
      expect(user.email, 'new@test.com');
      verify(() => mockLocal.cacheUser(any(), any())).called(1);
    });

    test('returns AuthFailure when email matches cached user', () async {
      when(() => mockLocal.getCachedUser())
          .thenReturn(const UserModel(id: 1, name: 'Existing', email: 'taken@test.com'));

      final result = await repo.register(
        name: 'Someone',
        email: 'taken@test.com',
        password: 'secret',
      );

      expect(result.isSuccess, isFalse);
      verifyNever(() => mockLocal.cacheUser(any(), any()));
    });

  });

  group('logout', () {
    test('calls clearUser on local datasource', () async {
      when(() => mockLocal.clearUser()).thenAnswer((_) async {});

      await repo.logout();

      verify(() => mockLocal.clearUser()).called(1);
    });
  });

  group('getCachedUser', () {
    test('returns ApiSuccess with user when cached', () {
      when(() => mockLocal.isLoggedIn).thenReturn(true);
      when(() => mockLocal.getCachedUser()).thenReturn(tUserModel);

      final result = repo.getCachedUser();

      expect(result.isSuccess, isTrue);
      expect(result.data, tUser);
    });

    test('returns ApiSuccess with null when not logged in', () {
      when(() => mockLocal.isLoggedIn).thenReturn(false);

      final result = repo.getCachedUser();

      expect(result.isSuccess, isTrue);
      expect(result.data, isNull);
    });

    test('returns ApiFailure when isLoggedIn but getCachedUser returns null', () {
      when(() => mockLocal.isLoggedIn).thenReturn(true);
      when(() => mockLocal.getCachedUser()).thenReturn(null);

      final result = repo.getCachedUser();

      expect(result.isSuccess, isFalse);
    });
  });
}
