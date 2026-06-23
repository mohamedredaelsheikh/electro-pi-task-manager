import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  final ApiClient _client;
  const TasksRemoteDataSource(this._client);

  Future<ApiResult<List<TaskModel>>> getUserTodos(int userId) =>
      _client.get<List<TaskModel>>(
        ApiConstants.userTodos(userId),
        fromJson: (data) => (data as List)
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<ApiResult<TaskModel>> updateTodo(
    int todoId,
    Map<String, dynamic> data,
  ) =>
      _client.patch<TaskModel>(
        ApiConstants.todo(todoId),
        data: data,
        fromJson: (json) => TaskModel.fromJson(json as Map<String, dynamic>),
      );

  Future<ApiResult<TaskModel>> createTodo({
    required int userId,
    required String title,
  }) =>
      _client.post<TaskModel>(
        ApiConstants.todos,
        data: {'userId': userId, 'title': title, 'completed': false},
        fromJson: (json) => TaskModel.fromJson(json as Map<String, dynamic>),
      );
}
