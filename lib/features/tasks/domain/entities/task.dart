import '../enums/task_priority.dart';
import '../enums/task_status.dart';

class Task {
  final int id;
  final int userId;
  final String title;
  final TaskStatus status;
  final TaskPriority priority;

  const Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.status,
    required this.priority,
  });

  Task copyWith({TaskStatus? status}) => Task(
        id: id,
        userId: userId,
        title: title,
        status: status ?? this.status,
        priority: priority,
      );

  @override
  bool operator ==(Object other) => other is Task && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
