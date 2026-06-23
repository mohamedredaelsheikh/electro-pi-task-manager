import '../../../../core/network/api_result.dart';
import '../entities/task.dart';
import '../enums/task_status.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskStatusUseCase {
  final TasksRepository _repository;
  const UpdateTaskStatusUseCase(this._repository);

  Future<ApiResult<Task>> call(int taskId, TaskStatus newStatus) =>
      _repository.updateTaskStatus(taskId, newStatus);
}
