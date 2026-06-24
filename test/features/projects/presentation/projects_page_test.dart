import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_state.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/pages/projects_page.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/widgets/project_card.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

Widget _buildApp(MockProjectsCubit cubit) {
  return BlocProvider<ProjectsCubit>.value(
    value: cubit,
    child: const MaterialApp(home: ProjectsPage()),
  );
}

void main() {
  late MockProjectsCubit mockCubit;

  setUp(() => mockCubit = MockProjectsCubit());

  testWidgets('shows loading indicator for ProjectsLoading', (tester) async {
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsLoading(),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state widget when list is empty', (tester) async {
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsLoaded([]),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.text('No projects yet'), findsOneWidget);
  });

  testWidgets('shows ProjectCard for each loaded project', (tester) async {
    const projects = [tProject];
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsLoaded(projects),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.byType(ProjectCard), findsNWidgets(projects.length));
    expect(find.text(tProject.title), findsOneWidget);
  });

  testWidgets('shows error view for ProjectsError', (tester) async {
    whenListen<ProjectsState>(
      mockCubit,
      Stream<ProjectsState>.empty(),
      initialState: const ProjectsError('Something went wrong'),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
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
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.tap(find.text('Retry'));
    await tester.pump();
    verify(() => mockCubit.loadProjects()).called(1);
  });
}
