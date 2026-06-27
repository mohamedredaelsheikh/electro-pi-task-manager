import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/projects/data/models/project_model.dart';
import 'package:electro_pi_task_manager/features/projects/data/repositories/projects_repository_impl.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late ProjectsRepositoryImpl repo;
  late MockProjectsRemoteDataSource mockRemote;
  late MockProjectsLocalDataSource mockLocal;

  setUpAll(() {
    registerFallbackValue(<ProjectModel>[]);
  });

  setUp(() {
    mockRemote = MockProjectsRemoteDataSource();
    mockLocal = MockProjectsLocalDataSource();
    repo = ProjectsRepositoryImpl(mockRemote, mockLocal);
  });

  test('calls remote with no args and saves result to cache on success', () async {
    when(() => mockRemote.getProjects())
        .thenAnswer((_) async => const ApiSuccess([tProjectModel]));
    when(() => mockLocal.saveProjects(any(), any()))
        .thenAnswer((_) async {});

    final result = await repo.getProjects();

    expect(result.isSuccess, isTrue);
    verify(() => mockRemote.getProjects()).called(1);
    verify(() => mockLocal.saveProjects(0, [tProjectModel])).called(1);
  });

  test('returns cached projects on NetworkFailure', () async {
    when(() => mockRemote.getProjects())
        .thenAnswer((_) async => const ApiFailure(NetworkFailure()));
    when(() => mockLocal.getProjects(0)).thenReturn([tProjectModel]);

    final result = await repo.getProjects();

    expect(result.isSuccess, isTrue);
    expect(result.data, [tProjectModel]);
  });

  test('propagates NetworkFailure when no cache exists', () async {
    when(() => mockRemote.getProjects())
        .thenAnswer((_) async => const ApiFailure(NetworkFailure()));
    when(() => mockLocal.getProjects(0)).thenReturn(null);

    final result = await repo.getProjects();
    expect(result.isSuccess, isFalse);
  });

  test('propagates non-network failure without reading cache', () async {
    when(() => mockRemote.getProjects())
        .thenAnswer((_) async => ApiFailure(ServerFailure('Server error', statusCode: 500)));

    final result = await repo.getProjects();
    expect(result.isSuccess, isFalse);
    verifyNever(() => mockLocal.getProjects(any()));
  });
}
