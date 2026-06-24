import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:electro_pi_task_manager/features/projects/presentation/cubit/projects_state.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockGetProjectsUseCase mockGetProjects;

  setUp(() => mockGetProjects = MockGetProjectsUseCase());

  blocTest<ProjectsCubit, ProjectsState>(
    'loadProjects emits [Loading, Loaded] on success',
    build: () {
      when(() => mockGetProjects())
          .thenAnswer((_) async => const ApiSuccess([tProject]));
      return ProjectsCubit(mockGetProjects);
    },
    act: (c) => c.loadProjects(),
    expect: () => [
      const ProjectsLoading(),
      isA<ProjectsLoaded>().having((s) => s.projects, 'projects', [tProject]),
    ],
  );

  blocTest<ProjectsCubit, ProjectsState>(
    'loadProjects emits [Loading, Error] on failure',
    build: () {
      when(() => mockGetProjects())
          .thenAnswer((_) async => const ApiFailure(NetworkFailure('no net')));
      return ProjectsCubit(mockGetProjects);
    },
    act: (c) => c.loadProjects(),
    expect: () => [
      const ProjectsLoading(),
      isA<ProjectsError>().having((s) => s.message, 'message', 'no net'),
    ],
  );
}
