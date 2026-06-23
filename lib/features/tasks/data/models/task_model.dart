import '../../domain/entities/task.dart';
import '../../domain/enums/task_priority.dart';
import '../../domain/enums/task_status.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.status,
    required super.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final completed = json['completed'] as bool? ?? false;
    return TaskModel(
      id: id,
      userId: json['userId'] as int,
      title: json['title'] as String,
      status: _deriveStatus(id, completed),
      priority: _derivePriority(id),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'completed': status.isDone,
      };

  // Completed todos are done; among incomplete ones alternate pending/inProgress.
  static TaskStatus _deriveStatus(int id, bool completed) {
    if (completed) return TaskStatus.done;
    return id.isEven ? TaskStatus.inProgress : TaskStatus.pending;
  }

  static TaskPriority _derivePriority(int id) => switch (id % 3) {
        0 => TaskPriority.high,
        1 => TaskPriority.medium,
        _ => TaskPriority.low,
      };
}
