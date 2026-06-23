import '../../../../core/network/api_result.dart';
import '../entities/project.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository _repository;
  const GetProjectsUseCase(this._repository);

  Future<ApiResult<List<Project>>> call() => _repository.getProjects();
}
