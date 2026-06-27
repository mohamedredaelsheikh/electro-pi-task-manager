import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/language/app_localizations.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_state.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/pages/projects_page.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/widgets/project_card.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/widgets/project_card_shimmer.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

Widget _buildApp(MockProjectsCubit cubit) {
  return ScreenUtilInit(
    designSize: const Size(402, 874),
    builder: (context, child) => BlocProvider<ProjectsCubit>.value(
      value: cubit,
      child: MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        home: const ProjectsPage(),
      ),
    ),
  );
}

Future<void> pumpPage(WidgetTester tester, MockProjectsCubit cubit) async {
  tester.view.physicalSize = const Size(402 * 2, 874 * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_buildApp(cubit));
  await tester.pump();
}

void main() {
  late MockProjectsCubit mockCubit;

  setUp(() => mockCubit = MockProjectsCubit());

  testWidgets('shows shimmer list for ProjectsLoading', (tester) async {
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsLoading(),
    );
    await pumpPage(tester, mockCubit);
    expect(find.byType(ProjectsShimmerList), findsOneWidget);
  });

  testWidgets('shows empty state widget when list is empty', (tester) async {
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsLoaded([]),
    );
    await pumpPage(tester, mockCubit);
    expect(find.text('No projects yet'), findsOneWidget);
  });

  testWidgets('shows ProjectCard for each loaded project', (tester) async {
    const projects = [tProject];
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsLoaded(projects),
    );
    await pumpPage(tester, mockCubit);
    expect(find.byType(ProjectCard), findsNWidgets(projects.length));
    expect(find.text(tProject.title), findsOneWidget);
  });

  testWidgets('shows error view for ProjectsError', (tester) async {
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsError('Something went wrong'),
    );
    await pumpPage(tester, mockCubit);
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('retry button calls loadProjects', (tester) async {
    when(() => mockCubit.loadProjects()).thenAnswer((_) async {});
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsError('err'),
    );
    await pumpPage(tester, mockCubit);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    verify(() => mockCubit.loadProjects()).called(1);
  });
}
