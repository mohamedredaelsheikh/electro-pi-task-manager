import '../../../../core/network/api_result.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase {
  final TasksRepository _repository;
  const CreateTaskUseCase(this._repository);

  Future<ApiResult<Task>> call({required String title}) =>
      _repository.createTask(title: title);
}
