import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/project_model.dart';

class ProjectsRemoteDataSource {
  final ApiClient _client;
  const ProjectsRemoteDataSource(this._client);

  // DummyJSON /users returns { users: [...], total, skip, limit }
  Future<ApiResult<List<ProjectModel>>> getProjects() =>
      _client.get<List<ProjectModel>>(
        ApiConstants.users,
        queryParameters: {'limit': '10', 'select': 'id,firstName,lastName,email'},
        fromJson: (data) {
          final list = (data as Map<String, dynamic>)['users'] as List;
          return list
              .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
}
