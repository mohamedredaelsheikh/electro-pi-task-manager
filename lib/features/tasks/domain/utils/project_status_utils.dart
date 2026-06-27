import '../../../projects/domain/enums/project_status.dart';
import '../entities/task.dart';
import '../enums/task_status.dart';

ProjectStatus deriveProjectStatus(List<Task> tasks) {
  if (tasks.isEmpty) return ProjectStatus.pending;
  if (tasks.every((t) => t.status == TaskStatus.done)) return ProjectStatus.done;
  if (tasks.any((t) => t.status != TaskStatus.pending)) return ProjectStatus.inProgress;
  return ProjectStatus.pending;
}
