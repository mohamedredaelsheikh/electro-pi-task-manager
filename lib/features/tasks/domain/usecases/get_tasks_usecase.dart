import '../../../../core/network/api_result.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository _repository;
  const GetTasksUseCase(this._repository);

  Future<ApiResult<List<Task>>> call(int projectId) =>
      _repository.getTasksByProject(projectId);
}
