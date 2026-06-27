import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_local_datasource.dart';
import '../datasources/tasks_remote_datasource.dart';
import '../models/task_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource _remote;
  final TasksLocalDataSource _local;

  const TasksRepositoryImpl(this._remote, this._local);

  @override
  Future<ApiResult<List<Task>>> getTasksByProject(int projectId) async {
    final result = await _remote.getTasksByProject(projectId);

    if (result case ApiSuccess(:final data)) {
      // Preserve locally-created tasks (negative IDs) across reloads —
      // the remote never returns them because DummyJSON doesn't persist POSTs.
      final cached = _local.getTasks(projectId) ?? [];
      final localOnly = cached
          .whereType<TaskModel>()
          .where((t) => t.id < 0)
          .toList();
      final merged = [...localOnly, ...data.whereType<TaskModel>()];
      await _local.saveTasks(projectId, merged);
      return ApiSuccess(merged);
    }

    final failure = (result as ApiFailure).failure;
    if (failure is NetworkFailure) {
      final cached = _local.getTasks(projectId);
      if (cached != null) return ApiSuccess(cached);
    }
    return ApiFailure(failure);
  }

  @override
  Future<ApiResult<Task>> updateTaskStatus(
      int taskId, TaskStatus newStatus, int projectId) async {
    // Locally-created task — no API call, update cache only.
    if (taskId < 0) {
      return _updateCacheOnly(taskId, newStatus, projectId);
    }

    final result = await _remote.updateTask(taskId, {'completed': newStatus.isDone});
    if (result case ApiSuccess(:final data)) {
      final updated = data.copyWith(status: newStatus);
      await _patchCache(taskId, updated, projectId);
      return ApiSuccess(updated);
    }
    return ApiFailure((result as ApiFailure).failure);
  }

  @override
  Future<ApiResult<Task>> createTask({
    required String title,
    required int projectId,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    final remoteResult = await _remote.createTask(
      projectId: projectId,
      title: title,
      priority: priority,
    );
    if (remoteResult case ApiFailure()) return remoteResult;

    // DummyJSON does not persist POSTs. Assign a unique negative local ID so
    // the task survives navigation and skips PATCH calls via taskId < 0 guard.
    // Microsecond timestamp gives a collision-free ID even under rapid creation.
    final localTask = TaskModel(
      id: -DateTime.now().microsecondsSinceEpoch,
      userId: projectId,
      title: title,
      status: TaskStatus.pending,
      priority: priority,
    );
    final cached = _local.getTasks(projectId) ?? [];
    await _local.saveTasks(
      projectId,
      [localTask, ...cached.whereType<TaskModel>()],
    );
    return ApiSuccess(localTask);
  }

  // Updates a local (negative-ID) task's status directly in cache.
  Future<ApiResult<Task>> _updateCacheOnly(
      int taskId, TaskStatus newStatus, int projectId) async {
    final cached = _local.getTasks(projectId);
    if (cached == null) return const ApiFailure(CacheFailure('Task not found.'));

    TaskModel? updated;
    final patched = cached.map((t) {
      if (t.id != taskId) return t;
      updated = TaskModel(
        id: t.id,
        userId: t.userId,
        title: t.title,
        status: newStatus,
        priority: t.priority,
      );
      return updated!;
    }).whereType<TaskModel>().toList();

    if (updated == null) return const ApiFailure(CacheFailure('Task not found.'));
    await _local.saveTasks(projectId, patched);
    return ApiSuccess(updated!);
  }

  // Replaces a single task entry in the cache after a successful API update.
  Future<void> _patchCache(int taskId, Task updated, int projectId) async {
    final cached = _local.getTasks(projectId);
    if (cached == null) return;
    final patched = cached.map((t) {
      if (t.id != taskId) return t;
      return TaskModel(
        id: updated.id,
        userId: updated.userId,
        title: updated.title,
        status: updated.status,
        priority: updated.priority,
      );
    }).whereType<TaskModel>().toList();
    await _local.saveTasks(projectId, patched);
  }
}
