import '../enums/project_status.dart';

class Project {
  final int id;
  final int userId;
  final String title;
  final String description;
  final ProjectStatus status;

  const Project({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  bool operator ==(Object other) => other is Project && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
