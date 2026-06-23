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
      final result = await _updateStatus(taskId, TaskStatus.done);
      if (result case ApiSuccess()) {
        final updated = tasks
            .map((t) => t.id == taskId ? t.copyWith(status: TaskStatus.done) : t)
            .toList();
        emit(TasksLoaded(updated));
      }
    }
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    final result = await _createTask(title: title.trim());
    if (result case ApiSuccess(:final data)) {
      // JSONPlaceholder returns id 201 for every POST — prepend locally.
      if (state case TasksLoaded(:final tasks)) {
        emit(TasksLoaded([data, ...tasks]));
      }
    }
  }
}
