import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/projects/domain/usecases/get_projects_usecase.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  test('GetProjectsUseCase delegates to repository', () async {
    final mockRepo = MockProjectsRepository();
    when(() => mockRepo.getProjects())
        .thenAnswer((_) async => const ApiSuccess([tProject]));

    final result = await GetProjectsUseCase(mockRepo)();

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.getProjects()).called(1);
  });
}
