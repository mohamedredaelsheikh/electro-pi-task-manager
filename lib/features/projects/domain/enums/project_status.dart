enum ProjectStatus { pending, inProgress, done }

extension ProjectStatusX on ProjectStatus {
  String get label => switch (this) {
        ProjectStatus.pending => 'Pending',
        ProjectStatus.inProgress => 'In Progress',
        ProjectStatus.done => 'Done',
      };
}
