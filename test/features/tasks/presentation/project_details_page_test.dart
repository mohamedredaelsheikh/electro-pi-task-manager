import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/pages/project_details_page.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/widgets/task_card.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

Widget _buildApp(MockTasksCubit cubit) {
  return BlocProvider<TasksCubit>.value(
    value: cubit,
    child: const MaterialApp(
      home: ProjectDetailsPage(projectId: 1, projectTitle: 'Test Project'),
    ),
  );
}

void main() {
  late MockTasksCubit mockCubit;

  setUp(() => mockCubit = MockTasksCubit());

  testWidgets('shows loading indicator for TasksLoading', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoading(),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when task list is empty', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([]),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('shows TaskCard for each loaded task', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([tTask, tDoneTask]),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.byType(TaskCard), findsNWidgets(2));
  });

  testWidgets('shows error view for TasksError', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksError('Load failed'),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.text('Load failed'), findsOneWidget);
  });

  testWidgets('FAB is visible in loaded state', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([tTask]),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Add task'), findsOneWidget);
  });

  testWidgets('tapping checkbox calls markAsDone', (tester) async {
    when(() => mockCubit.markAsDone(tTask.id)).thenAnswer((_) async {});
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([tTask]),
    );
    await tester.pumpWidget(_buildApp(mockCubit));
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    verify(() => mockCubit.markAsDone(tTask.id)).called(1);
  });
}
