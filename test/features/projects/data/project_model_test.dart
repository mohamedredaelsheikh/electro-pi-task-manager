import 'package:flutter_test/flutter_test.dart';
import 'package:electro_pi_task_manager/features/projects/data/models/project_model.dart';
import 'package:electro_pi_task_manager/features/projects/domain/enums/project_status.dart';

void main() {
  group('ProjectModel.fromJson', () {
    Map<String, dynamic> makeJson(int id) => {
          'id': id,
          'firstName': 'First$id',
          'lastName': 'Last$id',
          'email': 'user$id@example.com',
        };

    test('maps id, firstName+lastName to title, and email to description', () {
      final model = ProjectModel.fromJson(makeJson(4));
      expect(model.id, 4);
      expect(model.userId, 4);
      expect(model.title, 'First4 Last4');
      expect(model.description, 'user4@example.com');
    });

    test('id % 3 == 0 → done', () {
      expect(ProjectModel.fromJson(makeJson(3)).status, ProjectStatus.done);
      expect(ProjectModel.fromJson(makeJson(6)).status, ProjectStatus.done);
    });

    test('id % 3 == 1 → inProgress', () {
      expect(ProjectModel.fromJson(makeJson(1)).status, ProjectStatus.inProgress);
      expect(ProjectModel.fromJson(makeJson(4)).status, ProjectStatus.inProgress);
    });

    test('id % 3 == 2 → pending', () {
      expect(ProjectModel.fromJson(makeJson(2)).status, ProjectStatus.pending);
      expect(ProjectModel.fromJson(makeJson(5)).status, ProjectStatus.pending);
    });
  });
}
