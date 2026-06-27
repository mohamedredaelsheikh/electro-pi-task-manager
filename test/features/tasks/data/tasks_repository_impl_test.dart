import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/tasks/data/models/task_model.dart';
import 'package:electro_pi_task_manager/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_priority.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_status.dart';

import '../../../helpers/mocks.dart';

void main() {
  late TasksRepositoryImpl repo;
  late MockTasksRemoteDataSource mockRemote;
  late MockTasksLocalDataSource mockLocal;

  setUpAll(() {
    registerFallbackValue(TaskStatus.pending);
    registerFallbackValue(TaskPriority.medium);
    registerFallbackValue(<TaskModel>[]);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockRemote = MockTasksRemoteDataSource();
    mockLocal = MockTasksLocalDataSource();
    repo = TasksRepositoryImpl(mockRemote, mockLocal);
  });

  const taskModel = TaskModel(
    id: 11,
    userId: 1,
    title: 'T11',
    status: TaskStatus.pending,
    priority: TaskPriority.low,
  );

  group('getTasksByProject', () {
    test('calls remote with projectId and merges local-only tasks on success', () async {
      const localTask = TaskModel(
        id: -1,
        userId: 1,
        title: 'Local',
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      );
      when(() => mockRemote.getTasksByProject(1))
          .thenAnswer((_) async => const ApiSuccess([taskModel]));
      when(() => mockLocal.getTasks(1)).thenReturn([localTask]);
      when(() => mockLocal.saveTasks(any(), any())).thenAnswer((_) async {});

      final result = await repo.getTasksByProject(1);

      expect(result.isSuccess, isTrue);
      expect(result.data.length, 2);
      expect(result.data.first.id, -1);
      verify(() => mockRemote.getTasksByProject(1)).called(1);
    });

    test('returns cached tasks on NetworkFailure', () async {
      when(() => mockRemote.getTasksByProject(any()))
          .thenAnswer((_) async => const ApiFailure(NetworkFailure()));
      when(() => mockLocal.getTasks(1)).thenReturn([taskModel]);

      final result = await repo.getTasksByProject(1);

      expect(result.isSuccess, isTrue);
      expect(result.data.first.id, 11);
    });

    test('propagates NetworkFailure when no cache exists', () async {
      when(() => mockRemote.getTasksByProject(any()))
          .thenAnswer((_) async => const ApiFailure(NetworkFailure()));
      when(() => mockLocal.getTasks(any())).thenReturn(null);

      final result = await repo.getTasksByProject(1);
      expect(result.isSuccess, isFalse);
    });
  });

  group('updateTaskStatus', () {
    test('calls remote and applies status override on success', () async {
      const returned = TaskModel(
        id: 1,
        userId: 1,
        title: 'T',
        status: TaskStatus.pending,
        priority: TaskPriority.low,
      );
      when(() => mockRemote.updateTask(1, any()))
          .thenAnswer((_) async => const ApiSuccess(returned));
      when(() => mockLocal.getTasks(1)).thenReturn([returned]);
      when(() => mockLocal.saveTasks(any(), any())).thenAnswer((_) async {});

      final result = await repo.updateTaskStatus(1, TaskStatus.done, 1);

      expect(result.isSuccess, isTrue);
      expect(result.data.status, TaskStatus.done);
      verify(() => mockRemote.updateTask(1, {'completed': true})).called(1);
    });

    test('updates local task in cache without calling remote', () async {
      const localTask = TaskModel(
        id: -1,
        userId: 1,
        title: 'Local',
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      );
      when(() => mockLocal.getTasks(1)).thenReturn([localTask]);
      when(() => mockLocal.saveTasks(any(), any())).thenAnswer((_) async {});

      final result = await repo.updateTaskStatus(-1, TaskStatus.done, 1);

      expect(result.isSuccess, isTrue);
      expect(result.data.status, TaskStatus.done);
      verifyNever(() => mockRemote.updateTask(any(), any()));
    });

    test('propagates failure from remote', () async {
      when(() => mockRemote.updateTask(any(), any()))
          .thenAnswer((_) async => const ApiFailure(NetworkFailure()));

      final result = await repo.updateTaskStatus(1, TaskStatus.done, 1);
      expect(result.isSuccess, isFalse);
    });
  });

  group('createTask', () {
    test('returns task with negative local id and saves to cache', () async {
      when(() => mockRemote.createTask(
            projectId: any(named: 'projectId'),
            title: any(named: 'title'),
            priority: any(named: 'priority'),
          )).thenAnswer((_) async => const ApiSuccess(taskModel));
      when(() => mockLocal.getTasks(any())).thenReturn([]);
      when(() => mockLocal.saveTasks(any(), any())).thenAnswer((_) async {});

      final result = await repo.createTask(title: 'New Task', projectId: 1);

      expect(result.isSuccess, isTrue);
      expect(result.data.id, isNegative);
      expect(result.data.title, 'New Task');
    });

    test('assigns unique negative ids for multiple local tasks', () async {
      const existingLocal = TaskModel(
        id: -1,
        userId: 1,
        title: 'Existing',
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      );
      when(() => mockRemote.createTask(
            projectId: any(named: 'projectId'),
            title: any(named: 'title'),
            priority: any(named: 'priority'),
          )).thenAnswer((_) async => const ApiSuccess(taskModel));
      when(() => mockLocal.getTasks(any())).thenReturn([existingLocal]);
      when(() => mockLocal.saveTasks(any(), any())).thenAnswer((_) async {});

      final result = await repo.createTask(title: 'Second', projectId: 1);

      expect(result.isSuccess, isTrue);
      // ID must be negative and distinct from the existing local task (-1).
      expect(result.data.id, isNegative);
      expect(result.data.id, isNot(-1));
    });
  });
}
