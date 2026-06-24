import 'package:flutter_test/flutter_test.dart';
import 'package:electro_pi_task_manager/features/tasks/data/models/task_model.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_priority.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_status.dart';

void main() {
  Map<String, dynamic> _json({required int id, bool completed = false}) => {
        'id': id,
        'userId': 1,
        'title': 'Task $id',
        'completed': completed,
      };

  group('TaskModel.fromJson — status derivation', () {
    test('completed=true → done regardless of id parity', () {
      expect(TaskModel.fromJson(_json(id: 1, completed: true)).status, TaskStatus.done);
      expect(TaskModel.fromJson(_json(id: 2, completed: true)).status, TaskStatus.done);
    });

    test('completed=false, even id → inProgress', () {
      expect(TaskModel.fromJson(_json(id: 2)).status, TaskStatus.inProgress);
      expect(TaskModel.fromJson(_json(id: 10)).status, TaskStatus.inProgress);
    });

    test('completed=false, odd id → pending', () {
      expect(TaskModel.fromJson(_json(id: 1)).status, TaskStatus.pending);
      expect(TaskModel.fromJson(_json(id: 7)).status, TaskStatus.pending);
    });
  });

  group('TaskModel.fromJson — priority derivation', () {
    test('id % 3 == 0 → high', () {
      expect(TaskModel.fromJson(_json(id: 3)).priority, TaskPriority.high);
      expect(TaskModel.fromJson(_json(id: 6)).priority, TaskPriority.high);
    });

    test('id % 3 == 1 → medium', () {
      expect(TaskModel.fromJson(_json(id: 1)).priority, TaskPriority.medium);
      expect(TaskModel.fromJson(_json(id: 4)).priority, TaskPriority.medium);
    });

    test('id % 3 == 2 → low', () {
      expect(TaskModel.fromJson(_json(id: 2)).priority, TaskPriority.low);
      expect(TaskModel.fromJson(_json(id: 5)).priority, TaskPriority.low);
    });
  });

  group('TaskModel.fromJson — field mapping', () {
    test('maps id, userId, title correctly', () {
      final model = TaskModel.fromJson(_json(id: 5));
      expect(model.id, 5);
      expect(model.userId, 1);
      expect(model.title, 'Task 5');
    });
  });
}
