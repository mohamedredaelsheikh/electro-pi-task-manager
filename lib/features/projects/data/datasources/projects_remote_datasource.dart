import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/project_model.dart';

class ProjectsRemoteDataSource {
  final ApiClient _client;
  const ProjectsRemoteDataSource(this._client);

  Future<ApiResult<List<ProjectModel>>> getProjects(int userId) =>
      _client.get<List<ProjectModel>>(
        ApiConstants.userPosts(userId),
        fromJson: (data) => (data as List)
            .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
