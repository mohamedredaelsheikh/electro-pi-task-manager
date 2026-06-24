import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_state.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

AuthCubit _build({
  MockLoginUseCase? login,
  MockRegisterUseCase? register,
  MockLogoutUseCase? logout,
  MockCheckAuthUseCase? checkAuth,
}) {
  return AuthCubit(
    login: login ?? MockLoginUseCase(),
    register: register ?? MockRegisterUseCase(),
    logout: logout ?? MockLogoutUseCase(),
    checkAuth: checkAuth ?? MockCheckAuthUseCase(),
  );
}

void main() {
  late MockLoginUseCase mockLogin;
  late MockRegisterUseCase mockRegister;
  late MockLogoutUseCase mockLogout;
  late MockCheckAuthUseCase mockCheckAuth;

  setUp(() {
    mockLogin = MockLoginUseCase();
    mockRegister = MockRegisterUseCase();
    mockLogout = MockLogoutUseCase();
    mockCheckAuth = MockCheckAuthUseCase();
  });

  group('checkSession', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when user is cached',
      build: () {
        when(() => mockCheckAuth()).thenReturn(const ApiSuccess(tUser));
        return _build(checkAuth: mockCheckAuth);
      },
      act: (c) => c.checkSession(),
      expect: () => [
        isA<AuthAuthenticated>().having((s) => s.user, 'user', tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated when no cached user',
      build: () {
        when(() => mockCheckAuth()).thenReturn(const ApiSuccess(null));
        return _build(checkAuth: mockCheckAuth);
      },
      act: (c) => c.checkSession(),
      expect: () => const [AuthUnauthenticated()],
    );
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockLogin(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const ApiSuccess(tUser));
        return _build(login: mockLogin);
      },
      act: (c) => c.login(email: 'john@example.com', password: 'password'),
      expect: () => [
        const AuthLoading(),
        isA<AuthAuthenticated>().having((s) => s.user, 'user', tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockLogin(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const ApiFailure(AuthFailure('Bad creds')));
        return _build(login: mockLogin);
      },
      act: (c) => c.login(email: 'x@x.com', password: 'wrong'),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>().having((s) => s.message, 'message', 'Bad creds'),
      ],
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockRegister(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const ApiSuccess(tUser));
        return _build(register: mockRegister);
      },
      act: (c) => c.register(name: 'n', email: 'e@e.com', password: 'pass'),
      expect: () => [
        const AuthLoading(),
        isA<AuthAuthenticated>().having((s) => s.user, 'user', tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockRegister(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const ApiFailure(AuthFailure('Email taken')));
        return _build(register: mockRegister);
      },
      act: (c) => c.register(name: 'n', email: 'taken@e.com', password: 'pass'),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>().having((s) => s.message, 'message', 'Email taken'),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated',
      build: () {
        when(() => mockLogout()).thenAnswer((_) async => const ApiSuccess(null));
        return _build(logout: mockLogout);
      },
      act: (c) => c.logout(),
      expect: () => const [AuthUnauthenticated()],
    );
  });
}
