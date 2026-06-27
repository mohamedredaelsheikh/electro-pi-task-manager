import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_result.dart';
import '../../../projects/domain/enums/project_status.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';
import '../../domain/utils/project_status_utils.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final int projectId;
  final GetTasksUseCase _getTasks;
  final UpdateTaskStatusUseCase _updateStatus;
  final CreateTaskUseCase _createTask;
  final void Function(int projectId, ProjectStatus status)? _onStatusChanged;

  TasksCubit({
    required this.projectId,
    required GetTasksUseCase getTasks,
    required UpdateTaskStatusUseCase updateStatus,
    required CreateTaskUseCase createTask,
    void Function(int projectId, ProjectStatus status)? onStatusChanged,
  })  : _getTasks = getTasks,
        _updateStatus = updateStatus,
        _createTask = createTask,
        _onStatusChanged = onStatusChanged,
        super(const TasksInitial());

  Future<void> loadTasks() async {
    emit(const TasksLoading());
    final result = await _getTasks(projectId);
    switch (result) {
      case ApiSuccess(:final data):
        emit(TasksLoaded(data));
        _syncProjectStatus(data);
      case ApiFailure(:final failure):
        emit(TasksError(failure.message));
    }
  }

  Future<void> toggleStatus(int taskId) async {
    if (state case TasksLoaded(:final tasks)) {
      final task = tasks.where((t) => t.id == taskId).firstOrNull;
      if (task == null) return;
      final newStatus =
          task.status.isDone ? TaskStatus.pending : TaskStatus.done;

      final result = await _updateStatus(taskId, newStatus, projectId);
      if (result case ApiSuccess()) {
        final updated = tasks
            .map((t) => t.id == taskId ? t.copyWith(status: newStatus) : t)
            .toList();
        emit(TasksLoaded(updated));
        _syncProjectStatus(updated);
      }
    }
  }

  Future<void> addTask(
    String title, {
    TaskPriority priority = TaskPriority.medium,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

      final result = await _createTask(
      title: trimmed,
      priority: priority,
      projectId: projectId,
    );
    if (isClosed) return;

    if (result case ApiSuccess(:final data)) {
      // Use the current state after the await so any concurrent loadTasks()
      // refresh is not overwritten by a stale pre-call snapshot.
      final currentTasks = switch (state) {
        TasksLoaded(:final tasks) => tasks,
        _ => <Task>[],
      };
      final updated = [data, ...currentTasks];
      emit(TasksLoaded(updated));
      _syncProjectStatus(updated);
    }
  }

  void _syncProjectStatus(List<Task> tasks) {
    // Best-effort: a closed or unregistered ProjectsCubit must not
    // roll back a successfully-created task.
    try {
      _onStatusChanged?.call(projectId, deriveProjectStatus(tasks));
    } catch (_) {}
  }
}
