import '../../../../core/cache/hive_cache_client.dart';
import '../models/project_model.dart';

class ProjectsLocalDataSource {
  final HiveCacheClient _cache;

  const ProjectsLocalDataSource(this._cache);

  static String _key(int userId) => 'projects_$userId';

  List<ProjectModel>? getProjects(int userId) {
    final maps = _cache.getList(_key(userId));
    return maps?.map(ProjectModel.fromJson).toList();
  }

  Future<void> saveProjects(int userId, List<ProjectModel> projects) =>
      _cache.putList(_key(userId), projects.map((p) => p.toJson()).toList());
}
