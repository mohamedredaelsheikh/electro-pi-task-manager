import 'package:mocktail/mocktail.dart';

import 'package:electro_pi_task_manager/core/storage/token_storage.dart';
import 'package:electro_pi_task_manager/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:electro_pi_task_manager/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:electro_pi_task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/login_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/logout_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/domain/usecases/register_usecase.dart';
import 'package:electro_pi_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:electro_pi_task_manager/features/profile/domain/repositories/profile_repository.dart';
import 'package:electro_pi_task_manager/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:electro_pi_task_manager/features/projects/data/datasources/projects_local_datasource.dart';
import 'package:electro_pi_task_manager/features/projects/data/datasources/projects_remote_datasource.dart';
import 'package:electro_pi_task_manager/features/projects/domain/repositories/projects_repository.dart';
import 'package:electro_pi_task_manager/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:electro_pi_task_manager/features/tasks/data/datasources/tasks_local_datasource.dart';
import 'package:electro_pi_task_manager/features/tasks/data/datasources/tasks_remote_datasource.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/domain/usecases/update_task_status_usecase.dart';
import 'package:electro_pi_task_manager/features/tasks/presentation/cubit/tasks_cubit.dart';

// ── Repositories ──────────────────────────────────────────────────────────────
class MockAuthRepository extends Mock implements AuthRepository {}

class MockProjectsRepository extends Mock implements ProjectsRepository {}

class MockTasksRepository extends Mock implements TasksRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

// ── Data-sources ──────────────────────────────────────────────────────────────
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockProjectsRemoteDataSource extends Mock
    implements ProjectsRemoteDataSource {}

class MockProjectsLocalDataSource extends Mock
    implements ProjectsLocalDataSource {}

class MockTasksRemoteDataSource extends Mock implements TasksRemoteDataSource {}

class MockTasksLocalDataSource extends Mock implements TasksLocalDataSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

// ── Use-cases ─────────────────────────────────────────────────────────────────
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockCheckAuthUseCase extends Mock implements CheckAuthUseCase {}

class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockUpdateTaskStatusUseCase extends Mock
    implements UpdateTaskStatusUseCase {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

// ── Cubits (for widget tests) ─────────────────────────────────────────────────
class MockAuthCubit extends Mock implements AuthCubit {}

class MockProjectsCubit extends Mock implements ProjectsCubit {}

class MockTasksCubit extends Mock implements TasksCubit {}

class MockProfileCubit extends Mock implements ProfileCubit {}
