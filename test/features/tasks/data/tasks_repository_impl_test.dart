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
  late MockTokenStorage mockStorage;

  setUp(() {
    mockRemote = MockTasksRemoteDataSource();
    mockStorage = MockTokenStorage();
    repo = TasksRepositoryImpl(mockRemote, mockStorage);
  });

  const taskModel = TaskModel(id: 11, userId: 1, title: 'T11', status: TaskStatus.pending, priority: TaskPriority.low);
  const taskModel2 = TaskModel(id: 22, userId: 1, title: 'T22', status: TaskStatus.pending, priority: TaskPriority.high);

  group('getTasksByProject', () {
    test('filters todos by id % 10 == projectId % 10', () async {
      when(() => mockStorage.getUserId()).thenReturn(1);
      when(() => mockRemote.getUserTodos(1))
          .thenAnswer((_) async => ApiSuccess([taskModel, taskModel2]));

      // projectId=1 → filter: id%10==1 → only taskModel (11%10=1)
      final result = await repo.getTasksByProject(1);

      expect(result.isSuccess, isTrue);
      expect(result.data.length, 1);
      expect(result.data.first.id, 11);
    });

    test('clamps userId > 10 to 1', () async {
      when(() => mockStorage.getUserId()).thenReturn(99999);
      when(() => mockRemote.getUserTodos(1))
          .thenAnswer((_) async => const ApiSuccess([]));

      await repo.getTasksByProject(1);
      verify(() => mockRemote.getUserTodos(1)).called(1);
    });

    test('propagates failure', () async {
      when(() => mockStorage.getUserId()).thenReturn(1);
      when(() => mockRemote.getUserTodos(any()))
          .thenAnswer((_) async => const ApiFailure(NetworkFailure()));

      final result = await repo.getTasksByProject(1);
      expect(result.isSuccess, isFalse);
    });
  });

  group('updateTaskStatus', () {
    test('applies provided status locally on success', () async {
      const returned = TaskModel(id: 1, userId: 1, title: 'T', status: TaskStatus.pending, priority: TaskPriority.low);
      when(() => mockRemote.updateTodo(1, any()))
          .thenAnswer((_) async => const ApiSuccess(returned));

      final result = await repo.updateTaskStatus(1, TaskStatus.done);

      expect(result.isSuccess, isTrue);
      expect(result.data.status, TaskStatus.done);
    });

    test('propagates failure', () async {
      when(() => mockRemote.updateTodo(any(), any()))
          .thenAnswer((_) async => const ApiFailure(NetworkFailure()));

      final result = await repo.updateTaskStatus(1, TaskStatus.done);
      expect(result.isSuccess, isFalse);
    });
  });

  group('createTask', () {
    test('returns result from remote', () async {
      when(() => mockStorage.getUserId()).thenReturn(1);
      when(() => mockRemote.createTodo(userId: 1, title: 'New'))
          .thenAnswer((_) async => const ApiSuccess(taskModel));

      final result = await repo.createTask(title: 'New');
      expect(result.isSuccess, isTrue);
    });
  });
}
