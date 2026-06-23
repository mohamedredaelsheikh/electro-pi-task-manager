import '../../../../core/network/api_result.dart';
import '../entities/project.dart';

abstract interface class ProjectsRepository {
  Future<ApiResult<List<Project>>> getProjects();
}
