import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_status.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/update_task_status_usecase.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockTasksRepository mockRepo;

  setUp(() => mockRepo = MockTasksRepository());

  test('GetTasksUseCase delegates to repository', () async {
    when(() => mockRepo.getTasksByProject(1))
        .thenAnswer((_) async => const ApiSuccess([tTask]));

    final result = await GetTasksUseCase(mockRepo)(1);

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.getTasksByProject(1)).called(1);
  });

  test('UpdateTaskStatusUseCase delegates to repository', () async {
    when(() => mockRepo.updateTaskStatus(1, TaskStatus.done))
        .thenAnswer((_) async => const ApiSuccess(tDoneTask));

    final result = await UpdateTaskStatusUseCase(mockRepo)(1, TaskStatus.done);

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.updateTaskStatus(1, TaskStatus.done)).called(1);
  });

  test('CreateTaskUseCase overrides server id with unique negative id', () async {
    when(() => mockRepo.createTask(title: any(named: 'title')))
        .thenAnswer((_) async => const ApiSuccess(tTask)); // tTask has id=1

    final result = await CreateTaskUseCase(mockRepo)(title: 'New task');

    expect(result.isSuccess, isTrue);
    expect(result.data.id, isNegative);
    verify(() => mockRepo.createTask(title: 'New task')).called(1);
  });

  test('CreateTaskUseCase assigns different negative ids on consecutive calls', () async {
    when(() => mockRepo.createTask(title: any(named: 'title')))
        .thenAnswer((_) async => const ApiSuccess(tTask));

    final useCase = CreateTaskUseCase(mockRepo);
    final r1 = await useCase(title: 'A');
    final r2 = await useCase(title: 'B');

    expect(r1.data.id, isNot(r2.data.id));
    expect(r1.data.id, isNegative);
    expect(r2.data.id, isNegative);
  });
}
