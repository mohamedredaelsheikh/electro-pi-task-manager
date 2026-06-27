import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:toastification/toastification.dart';
import 'package:electro_pi_task_manager/core/language/app_localizations.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/pages/login_page.dart';

import '../../../helpers/mocks.dart';

Widget _buildApp(MockAuthCubit cubit) {
  return ScreenUtilInit(
    designSize: const Size(402, 874),
    builder: (context, child) => BlocProvider<AuthCubit>.value(
      value: cubit,
      child: MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        builder: (context, child) =>
            ToastificationWrapper(child: child ?? const SizedBox()),
        home: const LoginPage(),
      ),
    ),
  );
}

Future<void> pumpPage(WidgetTester tester, MockAuthCubit cubit) async {
  tester.view.physicalSize = const Size(402 * 2, 874 * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_buildApp(cubit));
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
    await pumpPage(tester, mockCubit);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('shows validation error when email is empty', (tester) async {
    await pumpPage(tester, mockCubit);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('shows validation error when password is too short', (
    tester,
  ) async {
    await pumpPage(tester, mockCubit);
    await tester.enterText(find.byType(TextFormField).first, 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('calls AuthCubit.login on valid submit', (tester) async {
    when(
      () => mockCubit.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    await pumpPage(tester, mockCubit);
    await tester.enterText(find.byType(TextFormField).first, 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
    await tester.pump();
    verify(
      () => mockCubit.login(
          email: 'john@example.com', password: 'password123'),
    ).called(1);
  });

  testWidgets('disables submit button when AuthLoading', (tester) async {
    whenListen<AuthState>(
      mockCubit,
      Stream<AuthState>.empty(),
      initialState: const AuthLoading(),
    );
    await pumpPage(tester, mockCubit);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('shows error snackbar on AuthError', (tester) async {
    whenListen<AuthState>(
      mockCubit,
      Stream.fromIterable([const AuthError('Invalid credentials')]),
      initialState: const AuthUnauthenticated(),
    );
    await pumpPage(tester, mockCubit);
    await tester.pump(); // event loop: stream emits → BlocListener → toastification.show() → overlay.insert
    await tester.pump(); // renders OverlayEntry → AnimatedList built
    await tester.pump(const Duration(milliseconds: 200)); // clock +200ms → Future.delayed(100ms) fires → insertItem
    await tester.pump(); // renders toast (SlideTransition starts off-screen → skipOffstage: false)
    expect(find.text('Invalid credentials', skipOffstage: false), findsOneWidget);
    // Flush auto-close timer (4s) and overlay removal timer (0.65s)
    await tester.pump(const Duration(seconds: 5));
  });
}
