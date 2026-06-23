import '../../domain/entities/task.dart';

sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {
  const TasksInitial();
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksLoaded extends TasksState {
  final List<Task> tasks;
  const TasksLoaded(this.tasks);
}

final class TasksError extends TasksState {
  final String message;
  const TasksError(this.message);
}
