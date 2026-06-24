import 'package:electro_pi_task_manager/features/auth/data/models/user_model.dart';
import 'package:electro_pi_task_manager/features/auth/domain/entities/user.dart';
import 'package:electro_pi_task_manager/features/projects/data/models/project_model.dart';
import 'package:electro_pi_task_manager/features/projects/domain/entities/project.dart';
import 'package:electro_pi_task_manager/features/projects/domain/enums/project_status.dart';
import 'package:electro_pi_task_manager/features/tasks/data/models/task_model.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/entities/task.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_priority.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/enums/task_status.dart';

const tUser = User(id: 1, name: 'John Doe', email: 'john@example.com');
const tUserModel = UserModel(id: 1, name: 'John Doe', email: 'john@example.com');

const tProject = Project(
  id: 1,
  userId: 1,
  title: 'Test Project',
  description: 'A test project description',
  status: ProjectStatus.inProgress,
);

const tProjectModel = ProjectModel(
  id: 1,
  userId: 1,
  title: 'Test Project',
  description: 'A test project description',
  status: ProjectStatus.inProgress,
);

const tTask = Task(
  id: 1,
  userId: 1,
  title: 'Test Task',
  status: TaskStatus.pending,
  priority: TaskPriority.medium,
);

const tTaskModel = TaskModel(
  id: 1,
  userId: 1,
  title: 'Test Task',
  status: TaskStatus.pending,
  priority: TaskPriority.medium,
);

const tDoneTask = Task(
  id: 2,
  userId: 1,
  title: 'Done Task',
  status: TaskStatus.done,
  priority: TaskPriority.low,
);

const tLocalTask = Task(
  id: -1,
  userId: 1,
  title: 'Local Task',
  status: TaskStatus.pending,
  priority: TaskPriority.medium,
);
