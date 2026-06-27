import '../../../../core/cache/hive_cache_client.dart';
import '../models/task_model.dart';

class TasksLocalDataSource {
  final HiveCacheClient _cache;

  const TasksLocalDataSource(this._cache);

  static String _key(int projectId) => 'tasks_$projectId';

  List<TaskModel>? getTasks(int projectId) {
    final maps = _cache.getList(_key(projectId));
    return maps?.map(TaskModel.fromJson).toList();
  }

  Future<void> saveTasks(int projectId, List<TaskModel> tasks) =>
      _cache.putList(_key(projectId), tasks.map((t) => t.toJson()).toList());
}
