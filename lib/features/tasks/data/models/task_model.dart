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
      status: completed ? TaskStatus.done : TaskStatus.pending,
      priority: _parsePriority(json['priority'] as String? ?? 'medium'),
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
}
