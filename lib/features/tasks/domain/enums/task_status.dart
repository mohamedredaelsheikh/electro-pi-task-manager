enum TaskStatus { pending, inProgress, done }

extension TaskStatusX on TaskStatus {
  String get label => switch (this) {
        TaskStatus.pending => 'Pending',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.done => 'Done',
      };

  bool get isDone => this == TaskStatus.done;
}
