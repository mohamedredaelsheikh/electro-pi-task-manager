import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/pages/login_page.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

Widget _buildApp(MockAuthCubit cubit) {
  return BlocProvider<AuthCubit>.value(
    value: cubit,
    child: const MaterialApp(home: LoginPage()),
  );
}

void main() {
  late MockAuthCubit mockCubit;

  setUp(() {
    mockCubit = MockAuthCubit();
    whenListen<AuthState>(
      mockCubit,
      Stream<AuthState>.empty(),
      initialState: const AuthUnauthenticated(),
    );
  });

  testWidgets('renders email and password fields', (tester) async {
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  });

  testWidgets('shows validation error when email is empty', (tester) async {
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('shows validation error when password is too short',
      (tester) async {
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'a@b.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'abc');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('calls AuthCubit.login on valid submit', (tester) async {
    when(() => mockCubit.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'john@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();
    verify(() => mockCubit.login(
          email: 'john@example.com',
          password: 'password123',
        )).called(1);
  });

  testWidgets('disables submit button when AuthLoading', (tester) async {
    whenListen<AuthState>(
      mockCubit,
      Stream<AuthState>.empty(),
      initialState: const AuthLoading(),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('shows error snackbar on AuthError', (tester) async {
    whenListen<AuthState>(
      mockCubit,
      Stream.fromIterable([const AuthError('Invalid credentials')]),
      initialState: const AuthUnauthenticated(),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.pump();
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
