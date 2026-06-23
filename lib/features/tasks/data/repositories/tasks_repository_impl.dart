import '../../../../core/network/api_result.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_datasource.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource _remote;
  final TokenStorage _storage;

  const TasksRepositoryImpl(this._remote, this._storage);

  @override
  Future<ApiResult<List<Task>>> getTasksByProject(int projectId) async {
    final userId = _effectiveUserId;
    final result = await _remote.getUserTodos(userId);

    if (result case ApiSuccess(:final data)) {
      // Deterministically associate each todo to a project using modulo.
      // User 1 has 10 projects (posts) and 20 todos → ~2 tasks per project.
      final tasks = data.where((t) => t.id % 10 == projectId % 10).toList();
      return ApiSuccess(tasks);
    }
    return ApiFailure((result as ApiFailure).failure);
  }

  @override
  Future<ApiResult<Task>> updateTaskStatus(
      int taskId, TaskStatus newStatus) async {
    final result = await _remote.updateTodo(
      taskId,
      {'completed': newStatus.isDone},
    );
    if (result case ApiSuccess(:final data)) {
      // JSONPlaceholder echoes completed; re-apply full status locally.
      return ApiSuccess(data.copyWith(status: newStatus));
    }
    return ApiFailure((result as ApiFailure).failure);
  }

  @override
  Future<ApiResult<Task>> createTask({required String title}) =>
      _remote.createTodo(userId: _effectiveUserId, title: title);

  int get _effectiveUserId {
    final id = _storage.getUserId() ?? 1;
    // JSONPlaceholder only has users 1–10.
    return id <= 10 ? id : 1;
  }
}
