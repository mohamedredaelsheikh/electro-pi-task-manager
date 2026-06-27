import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_datasource.dart';
import '../datasources/projects_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource _remote;
  final ProjectsLocalDataSource _local;

  const ProjectsRepositoryImpl(this._remote, this._local);

  static const int _cacheKey = 0;

  @override
  Future<ApiResult<List<Project>>> getProjects() async {
    final result = await _remote.getProjects();
    switch (result) {
      case ApiSuccess(:final data):
        await _local.saveProjects(
          _cacheKey,
          data.whereType<ProjectModel>().toList(),
        );
        return result;
      case ApiFailure(:final failure):
        if (failure is NetworkFailure) {
          final cached = _local.getProjects(_cacheKey);
          if (cached != null) return ApiSuccess(cached);
        }
        return result;
    }
  }
}
