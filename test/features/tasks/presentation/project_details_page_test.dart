import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/pages/project_details_page.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/widgets/task_card.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/widgets/task_card_shimmer.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

Widget _buildApp(MockTasksCubit cubit) {
  return ScreenUtilInit(
    designSize: const Size(402, 874),
    builder: (context, child) => BlocProvider<TasksCubit>.value(
      value: cubit,
      child: const MaterialApp(
        home: ProjectDetailsPage(projectId: 1, projectTitle: 'Test Project'),
      ),
    ),
  );
}

/// Pumps the page with screen size matching the design size to avoid
/// ScreenUtil scaling overflow errors in the test environment.
Future<void> pumpPage(WidgetTester tester, MockTasksCubit cubit) async {
  tester.view.physicalSize = const Size(402 * 2, 874 * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_buildApp(cubit));
}

void main() {
  late MockTasksCubit mockCubit;

  setUp(() => mockCubit = MockTasksCubit());

  testWidgets('shows shimmer list for TasksLoading', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoading(),
    );
    await pumpPage(tester, mockCubit);
    expect(find.byType(TasksShimmerList), findsOneWidget);
  });

  testWidgets('shows empty state when task list is empty', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([]),
    );
    await pumpPage(tester, mockCubit);
    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('shows TaskCard for each loaded task', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([tTask, tDoneTask]),
    );
    await pumpPage(tester, mockCubit);
    expect(find.byType(TaskCard), findsNWidgets(2));
  });

  testWidgets('shows error view for TasksError', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksError('Load failed'),
    );
    await pumpPage(tester, mockCubit);
    expect(find.text('Load failed'), findsOneWidget);
  });

  testWidgets('FAB is visible in loaded state', (tester) async {
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([tTask]),
    );
    await pumpPage(tester, mockCubit);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
  });

  testWidgets('tapping task card calls toggleStatus', (tester) async {
    when(() => mockCubit.toggleStatus(tTask.id)).thenAnswer((_) async {});
    whenListen<TasksState>(
      mockCubit,
      Stream<TasksState>.empty(),
      initialState: const TasksLoaded([tTask]),
    );
    await pumpPage(tester, mockCubit);
    await tester.tap(find.byType(TaskCard).first);
    await tester.pump();
    verify(() => mockCubit.toggleStatus(tTask.id)).called(1);
  });
}
