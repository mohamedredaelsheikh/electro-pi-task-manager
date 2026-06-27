import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_priority.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_status.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/update_task_status_usecase.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockTasksRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(TaskStatus.pending);
    registerFallbackValue(TaskPriority.medium);
  });

  setUp(() => mockRepo = MockTasksRepository());

  test('GetTasksUseCase delegates to repository', () async {
    when(() => mockRepo.getTasksByProject(1))
        .thenAnswer((_) async => const ApiSuccess([tTask]));

    final result = await GetTasksUseCase(mockRepo)(1);

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.getTasksByProject(1)).called(1);
  });

  test('UpdateTaskStatusUseCase delegates to repository with projectId', () async {
    when(() => mockRepo.updateTaskStatus(1, TaskStatus.done, 1))
        .thenAnswer((_) async => const ApiSuccess(tDoneTask));

    final result = await UpdateTaskStatusUseCase(mockRepo)(1, TaskStatus.done, 1);

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.updateTaskStatus(1, TaskStatus.done, 1)).called(1);
  });

  test('CreateTaskUseCase delegates to repository with projectId', () async {
    when(() => mockRepo.createTask(
          title: any(named: 'title'),
          projectId: any(named: 'projectId'),
        )).thenAnswer((_) async => const ApiSuccess(tTask));

    final result = await CreateTaskUseCase(mockRepo)(title: 'New task', projectId: 1);

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.createTask(title: 'New task', projectId: 1)).called(1);
  });
}
