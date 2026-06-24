import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/projects/data/repositories/projects_repository_impl.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late ProjectsRepositoryImpl repo;
  late MockProjectsRemoteDataSource mockRemote;
  late MockTokenStorage mockStorage;

  setUp(() {
    mockRemote = MockProjectsRemoteDataSource();
    mockStorage = MockTokenStorage();
    repo = ProjectsRepositoryImpl(mockRemote, mockStorage);
  });

  test('calls remote with userId from storage', () async {
    when(() => mockStorage.getUserId()).thenReturn(3);
    when(() => mockRemote.getProjects(3))
        .thenAnswer((_) async => ApiSuccess([tProjectModel]));

    await repo.getProjects();

    verify(() => mockRemote.getProjects(3)).called(1);
  });

  test('clamps userId > 10 to 1', () async {
    when(() => mockStorage.getUserId()).thenReturn(50000);
    when(() => mockRemote.getProjects(1))
        .thenAnswer((_) async => ApiSuccess([tProjectModel]));

    await repo.getProjects();

    verify(() => mockRemote.getProjects(1)).called(1);
  });

  test('uses userId=1 when storage returns null', () async {
    when(() => mockStorage.getUserId()).thenReturn(null);
    when(() => mockRemote.getProjects(1))
        .thenAnswer((_) async => ApiSuccess([tProjectModel]));

    await repo.getProjects();

    verify(() => mockRemote.getProjects(1)).called(1);
  });

  test('propagates ApiFailure from remote', () async {
    when(() => mockStorage.getUserId()).thenReturn(1);
    when(() => mockRemote.getProjects(any()))
        .thenAnswer((_) async => const ApiFailure(NetworkFailure()));

    final result = await repo.getProjects();
    expect(result.isSuccess, isFalse);
  });
}
