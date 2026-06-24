import '../../../../core/network/api_result.dart';
import '../entities/task.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase {
  final TasksRepository _repository;

  // JSONPlaceholder always returns id=201 for every POST. Use a descending
  // negative counter (shared across all callers via the singleton registration)
  // so every locally-created task gets a globally unique id that never collides
  // with a real server id.
  int _nextLocalId = -1;

  CreateTaskUseCase(this._repository);

  Future<ApiResult<Task>> call({required String title}) async {
    final result = await _repository.createTask(title: title);
    if (result case ApiSuccess(:final data)) {
      return ApiSuccess(Task(
        id: _nextLocalId--,
        userId: data.userId,
        title: data.title,
        status: data.status,
        priority: data.priority,
      ));
    }
    return result;
  }
}
