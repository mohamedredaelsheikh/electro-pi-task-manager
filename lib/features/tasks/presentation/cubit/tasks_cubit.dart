import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_result.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final int projectId;
  final GetTasksUseCase _getTasks;
  final UpdateTaskStatusUseCase _updateStatus;
  final CreateTaskUseCase _createTask;

  TasksCubit({
    required this.projectId,
    required GetTasksUseCase getTasks,
    required UpdateTaskStatusUseCase updateStatus,
    required CreateTaskUseCase createTask,
  })  : _getTasks = getTasks,
        _updateStatus = updateStatus,
        _createTask = createTask,
        super(const TasksInitial());

  Future<void> loadTasks() async {
    emit(const TasksLoading());
    final result = await _getTasks(projectId);
    switch (result) {
      case ApiSuccess(:final data):
        emit(TasksLoaded(data));
      case ApiFailure(:final failure):
        emit(TasksError(failure.message));
    }
  }

  Future<void> markAsDone(int taskId) async {
    if (state case TasksLoaded(:final tasks)) {
      if (taskId < 0) {
        // Locally-created task — update state directly without an API call.
        emit(TasksLoaded(
          tasks.map((t) => t.id == taskId ? t.copyWith(status: TaskStatus.done) : t).toList(),
        ));
        return;
      }
      final result = await _updateStatus(taskId, TaskStatus.done);
      if (result case ApiSuccess()) {
        emit(TasksLoaded(
          tasks.map((t) => t.id == taskId ? t.copyWith(status: TaskStatus.done) : t).toList(),
        ));
      }
    }
  }

  Future<void> addTask(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final result = await _createTask(title: trimmed);
    if (isClosed) return;
    if (result case ApiSuccess(:final data)) {
      if (state case TasksLoaded(:final tasks)) {
        emit(TasksLoaded([data, ...tasks]));
      }
    }
  }
}
