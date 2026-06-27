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

  // DummyJSON todo: { id, todo, completed, userId }
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final completed = json['completed'] as bool? ?? false;
    return TaskModel(
      id: id,
      userId: json['userId'] as int? ?? 0,
      title: (json['todo'] ?? json['title']) as String,
      status: completed
          ? TaskStatus.done
          : (id % 2 == 0 ? TaskStatus.inProgress : TaskStatus.pending),
      priority: json['priority'] != null
          ? _parsePriority(json['priority'] as String)
          : _derivePriority(id),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'todo': title,
        'completed': status.isDone,
        'priority': priority.name,
      };

  static TaskPriority _parsePriority(String value) => switch (value) {
        'high' => TaskPriority.high,
        'low' => TaskPriority.low,
        _ => TaskPriority.medium,
      };

  static TaskPriority _derivePriority(int id) => switch (id % 3) {
        0 => TaskPriority.high,
        2 => TaskPriority.low,
        _ => TaskPriority.medium,
      };
}
