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

  // DummyJSON user: { id, firstName, lastName, email, ... }
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    return ProjectModel(
      id: id,
      userId: id,
      title: '$firstName $lastName'.trim(),
      description: json['email'] as String? ?? '',
      status: _deriveStatus(id),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': title.split(' ').first,
        'lastName': title.split(' ').skip(1).join(' '),
        'email': description,
      };

  static ProjectStatus _deriveStatus(int id) => switch (id % 3) {
        0 => ProjectStatus.done,
        1 => ProjectStatus.inProgress,
        _ => ProjectStatus.pending,
      };
}
