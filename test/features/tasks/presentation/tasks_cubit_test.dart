import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_priority.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_status.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_state.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

TasksCubit _build({
  required MockGetTasksUseCase getTasks,
  required MockUpdateTaskStatusUseCase updateStatus,
  required MockCreateTaskUseCase createTask,
  int projectId = 1,
}) {
  return TasksCubit(
    projectId: projectId,
    getTasks: getTasks,
    updateStatus: updateStatus,
    createTask: createTask,
  );
}

void main() {
  late MockGetTasksUseCase mockGetTasks;
  late MockUpdateTaskStatusUseCase mockUpdateStatus;
  late MockCreateTaskUseCase mockCreateTask;

  setUpAll(() {
    registerFallbackValue(TaskStatus.pending);
    registerFallbackValue(TaskPriority.medium);
  });

  setUp(() {
    mockGetTasks = MockGetTasksUseCase();
    mockUpdateStatus = MockUpdateTaskStatusUseCase();
    mockCreateTask = MockCreateTaskUseCase();
  });

  group('loadTasks', () {
    blocTest<TasksCubit, TasksState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetTasks(1))
            .thenAnswer((_) async => const ApiSuccess([tTask]));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      act: (c) => c.loadTasks(),
      expect: () => [
        const TasksLoading(),
        isA<TasksLoaded>().having((s) => s.tasks, 'tasks', [tTask]),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetTasks(any()))
            .thenAnswer(
                (_) async => const ApiFailure(NetworkFailure('offline')));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      act: (c) => c.loadTasks(),
      expect: () => [
        const TasksLoading(),
        isA<TasksError>().having((s) => s.message, 'message', 'offline'),
      ],
    );
  });

  group('toggleStatus', () {
    blocTest<TasksCubit, TasksState>(
      'updates the matching task to done on API success',
      build: () {
        when(() => mockUpdateStatus(tTask.id, TaskStatus.done, 1))
            .thenAnswer(
                (_) async => ApiSuccess(tTask.copyWith(status: TaskStatus.done)));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      seed: () => const TasksLoaded([tTask]),
      act: (c) => c.toggleStatus(tTask.id),
      expect: () => [
        isA<TasksLoaded>().having(
          (s) => s.tasks.first.status,
          'task status',
          TaskStatus.done,
        ),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'does not emit when state is not TasksLoaded',
      build: () => _build(
          getTasks: mockGetTasks,
          updateStatus: mockUpdateStatus,
          createTask: mockCreateTask),
      act: (c) => c.toggleStatus(1),
      expect: () => [],
      verify: (c) => verifyNever(() => mockUpdateStatus(any(), any(), any())),
    );

    blocTest<TasksCubit, TasksState>(
      'calls use case for local task and marks done on success',
      build: () {
        when(() => mockUpdateStatus(tLocalTask.id, TaskStatus.done, 1))
            .thenAnswer((_) async => const ApiSuccess(tLocalTask));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      seed: () => const TasksLoaded([tLocalTask]),
      act: (c) => c.toggleStatus(tLocalTask.id),
      expect: () => [
        isA<TasksLoaded>().having(
          (s) => s.tasks.first.status,
          'task status',
          TaskStatus.done,
        ),
      ],
      verify: (c) =>
          verify(() => mockUpdateStatus(tLocalTask.id, TaskStatus.done, 1))
              .called(1),
    );

    blocTest<TasksCubit, TasksState>(
      'does not emit when API call fails',
      build: () {
        when(() => mockUpdateStatus(any(), any(), any()))
            .thenAnswer((_) async => const ApiFailure(NetworkFailure()));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      seed: () => const TasksLoaded([tTask]),
      act: (c) => c.toggleStatus(tTask.id),
      expect: () => [],
    );
  });

  group('addTask', () {
    blocTest<TasksCubit, TasksState>(
      'prepends the task returned by the use case on success',
      build: () {
        when(() => mockCreateTask(
              title: any(named: 'title'),
              projectId: any(named: 'projectId'),
              priority: any(named: 'priority'),
            )).thenAnswer((_) async => const ApiSuccess(tLocalTask));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      seed: () => const TasksLoaded([]),
      act: (c) => c.addTask('New Task'),
      expect: () => [
        isA<TasksLoaded>()
            .having((s) => s.tasks.first, 'first task', tLocalTask),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'two consecutive adds each prepend the returned task',
      build: () {
        when(() => mockCreateTask(
              title: any(named: 'title'),
              projectId: any(named: 'projectId'),
              priority: any(named: 'priority'),
            )).thenAnswer((_) async => const ApiSuccess(tLocalTask));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      seed: () => const TasksLoaded([tDoneTask]),
      act: (c) async {
        await c.addTask('Task A');
        await c.addTask('Task B');
      },
      expect: () => [
        isA<TasksLoaded>()
            .having((s) => s.tasks.length, 'length after first add', 2),
        isA<TasksLoaded>()
            .having((s) => s.tasks.length, 'length after second add', 3),
      ],
    );

    blocTest<TasksCubit, TasksState>(
      'does nothing when title is blank',
      build: () => _build(
          getTasks: mockGetTasks,
          updateStatus: mockUpdateStatus,
          createTask: mockCreateTask),
      seed: () => const TasksLoaded([]),
      act: (c) => c.addTask('   '),
      expect: () => [],
    );

    blocTest<TasksCubit, TasksState>(
      'adds task to empty list when called from non-loaded state',
      build: () {
        when(() => mockCreateTask(
              title: any(named: 'title'),
              projectId: any(named: 'projectId'),
              priority: any(named: 'priority'),
            )).thenAnswer((_) async => const ApiSuccess(tTask));
        return _build(
            getTasks: mockGetTasks,
            updateStatus: mockUpdateStatus,
            createTask: mockCreateTask);
      },
      act: (c) => c.addTask('orphan'),
      expect: () => [
        isA<TasksLoaded>().having((s) => s.tasks, 'tasks', [tTask]),
      ],
    );
  });
}
