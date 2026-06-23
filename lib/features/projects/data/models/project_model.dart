import '../../domain/entities/project.dart';
import '../../domain/enums/project_status.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.status,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    return ProjectModel(
      id: id,
      userId: json['userId'] as int,
      title: json['title'] as String,
      description: json['body'] as String,
      status: _deriveStatus(id),
    );
  }

  // Derive a stable status from the post id so the list feels realistic.
  static ProjectStatus _deriveStatus(int id) => switch (id % 3) {
        0 => ProjectStatus.done,
        1 => ProjectStatus.inProgress,
        _ => ProjectStatus.pending,
      };
}
