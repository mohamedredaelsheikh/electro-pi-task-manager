import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/enums/task_priority.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  final ApiClient _client;
  const TasksRemoteDataSource(this._client);

  // DummyJSON /todos/user/:id returns { todos: [...], total, skip, limit }
  Future<ApiResult<List<TaskModel>>> getTasksByProject(int projectId) =>
      _client.get<List<TaskModel>>(
        ApiConstants.userTodos(projectId),
        fromJson: (data) {
          final list = (data as Map<String, dynamic>)['todos'] as List;
          return list
              .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );

  Future<ApiResult<TaskModel>> updateTask(
    int id,
    Map<String, dynamic> data,
  ) =>
      _client.patch<TaskModel>(
        ApiConstants.todo(id),
        data: data,
        fromJson: (json) => TaskModel.fromJson(json as Map<String, dynamic>),
      );

  // DummyJSON POST /todos/add returns the new todo (fake persist, id starts at 201+)
  Future<ApiResult<TaskModel>> createTask({
    required int projectId,
    required String title,
    TaskPriority priority = TaskPriority.medium,
  }) =>
      _client.post<TaskModel>(
        ApiConstants.addTodo,
        data: {
          'todo': title,
          'completed': false,
          'userId': projectId,
          'priority': priority.name,
        },
        fromJson: (json) => TaskModel.fromJson(json as Map<String, dynamic>),
      );
}
