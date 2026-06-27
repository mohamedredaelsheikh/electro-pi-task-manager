import '../../../../core/network/api_result.dart';
import '../entities/task.dart';
import '../enums/task_priority.dart';
import '../enums/task_status.dart';

abstract interface class TasksRepository {
  Future<ApiResult<List<Task>>> getTasksByProject(int projectId);
  Future<ApiResult<Task>> updateTaskStatus(
      int taskId, TaskStatus newStatus, int projectId);
  Future<ApiResult<Task>> createTask({
    required String title,
    required int projectId,
    TaskPriority priority = TaskPriority.medium,
  });
}
