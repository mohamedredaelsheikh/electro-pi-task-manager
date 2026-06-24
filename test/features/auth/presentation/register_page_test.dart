import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/pages/register_page.dart';

import '../../../helpers/mocks.dart';

Widget _buildApp(MockAuthCubit cubit) {
  return BlocProvider<AuthCubit>.value(
    value: cubit,
    child: const MaterialApp(home: RegisterPage()),
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

  testWidgets('renders all four form fields', (tester) async {
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.widgetWithText(TextFormField, 'Full name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Confirm password'), findsOneWidget);
  });

  testWidgets('shows error when name is empty', (tester) async {
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    expect(find.text('Name is required'), findsOneWidget);
  });

  testWidgets('shows error when passwords do not match', (tester) async {
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'), 'Alice');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'alice@x.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'password1');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'), 'password2');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('calls AuthCubit.register on valid submit', (tester) async {
    when(() => mockCubit.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'), 'Alice');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'alice@x.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret1');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pump();

    verify(() => mockCubit.register(
          name: 'Alice',
          email: 'alice@x.com',
          password: 'secret1',
        )).called(1);
  });

  testWidgets('shows snackbar on AuthError', (tester) async {
    whenListen<AuthState>(
      mockCubit,
      Stream.fromIterable([const AuthError('Email taken')]),
      initialState: const AuthUnauthenticated(),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.pump();
    expect(find.text('Email taken'), findsOneWidget);
  });
}
