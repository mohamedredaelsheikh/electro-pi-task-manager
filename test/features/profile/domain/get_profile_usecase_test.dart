import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/profile/domain/usecases/get_profile_usecase.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  test('GetProfileUseCase delegates to repository', () {
    final mockRepo = MockProfileRepository();
    when(() => mockRepo.getProfile()).thenReturn(const ApiSuccess(tUser));

    final result = GetProfileUseCase(mockRepo)();

    expect(result.isSuccess, isTrue);
    verify(() => mockRepo.getProfile()).called(1);
  });
}
