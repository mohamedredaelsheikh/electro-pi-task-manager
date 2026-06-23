import '../../../../core/network/api_result.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_remote_datasource.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource _remote;
  final TokenStorage _storage;

  const ProjectsRepositoryImpl(this._remote, this._storage);

  @override
  Future<ApiResult<List<Project>>> getProjects() {
    final rawId = _storage.getUserId() ?? 1;
    // JSONPlaceholder only has users 1–10; fall back to 1 for locally-registered users.
    final userId = rawId <= 10 ? rawId : 1;
    return _remote.getProjects(userId);
  }
}
