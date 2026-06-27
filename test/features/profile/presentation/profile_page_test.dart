import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/language/app_localizations.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:electro_pi_task_manager/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:electro_pi_task_manager/features/profile/presentation/cubit/profile_state.dart';
import 'package:electro_pi_task_manager/features/profile/presentation/pages/profile_page.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

Widget _buildApp(MockProfileCubit profileCubit, MockAuthCubit authCubit) {
  return ScreenUtilInit(
    designSize: const Size(402, 874),
    builder: (context, child) => MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<AuthCubit>.value(value: authCubit),
      ],
      child: MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: const ProfilePage(),
      ),
    ),
  );
}

Future<void> pumpPage(
  WidgetTester tester,
  MockProfileCubit profileCubit,
  MockAuthCubit authCubit,
) async {
  tester.view.physicalSize = const Size(402 * 2, 874 * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_buildApp(profileCubit, authCubit));
  await tester.pump();
}

void main() {
  late MockProfileCubit mockProfile;
  late MockAuthCubit mockAuth;

  setUp(() {
    mockProfile = MockProfileCubit();
    mockAuth = MockAuthCubit();
    whenListen<AuthState>(
      mockAuth,
      Stream<AuthState>.empty(),
      initialState: const AuthAuthenticated(tUser),
    );
  });

  testWidgets('shows name and email when ProfileLoaded', (tester) async {
    whenListen<ProfileState>(
      mockProfile,
      Stream<ProfileState>.empty(),
      initialState: const ProfileLoaded(tUser),
    );
    await pumpPage(tester, mockProfile, mockAuth);
    expect(find.text(tUser.name), findsWidgets);
    expect(find.text(tUser.email), findsWidgets);
  });

  testWidgets('shows error message when ProfileError', (tester) async {
    whenListen<ProfileState>(
      mockProfile,
      Stream<ProfileState>.empty(),
      initialState: const ProfileError('Profile not found'),
    );
    await pumpPage(tester, mockProfile, mockAuth);
    expect(find.text('Profile not found'), findsOneWidget);
  });

  testWidgets('logout button calls AuthCubit.logout', (tester) async {
    when(() => mockAuth.logout()).thenAnswer((_) async {});
    whenListen<ProfileState>(
      mockProfile,
      Stream<ProfileState>.empty(),
      initialState: const ProfileLoaded(tUser),
    );
    await pumpPage(tester, mockProfile, mockAuth);
    await tester.tap(find.text('Sign Out'));
    await tester.pump();
    verify(() => mockAuth.logout()).called(1);
  });
}
