import 'package:flutter_test/flutter_test.dart';
import 'package:electro_pi_task_manager/features/projects/data/models/project_model.dart';
import 'package:electro_pi_task_manager/features/projects/domain/enums/project_status.dart';

void main() {
  group('ProjectModel.fromJson', () {
    Map<String, dynamic> _json(int id) => {
          'id': id,
          'userId': 1,
          'title': 'Title $id',
          'body': 'Body $id',
        };

    test('maps id, userId, title, and body to description', () {
      final model = ProjectModel.fromJson(_json(4));
      expect(model.id, 4);
      expect(model.userId, 1);
      expect(model.title, 'Title 4');
      expect(model.description, 'Body 4');
    });

    test('id % 3 == 0 → done', () {
      expect(ProjectModel.fromJson(_json(3)).status, ProjectStatus.done);
      expect(ProjectModel.fromJson(_json(6)).status, ProjectStatus.done);
    });

    test('id % 3 == 1 → inProgress', () {
      expect(ProjectModel.fromJson(_json(1)).status, ProjectStatus.inProgress);
      expect(ProjectModel.fromJson(_json(4)).status, ProjectStatus.inProgress);
    });

    test('id % 3 == 2 → pending', () {
      expect(ProjectModel.fromJson(_json(2)).status, ProjectStatus.pending);
      expect(ProjectModel.fromJson(_json(5)).status, ProjectStatus.pending);
    });
  });
}
