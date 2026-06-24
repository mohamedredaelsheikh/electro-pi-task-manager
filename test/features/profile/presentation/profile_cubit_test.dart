import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:electro_pi_task_manager/core/error/failures.dart';
import 'package:electro_pi_task_manager/core/network/api_result.dart';
import 'package:electro_pi_task_manager/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:electro_pi_task_manager/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:electro_pi_task_manager/features/profile/presentation/cubit/profile_state.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockProfileRepository mockRepo;

  setUp(() => mockRepo = MockProfileRepository());

  blocTest<ProfileCubit, ProfileState>(
    'loadProfile emits ProfileLoaded on success',
    build: () {
      when(() => mockRepo.getProfile()).thenReturn(const ApiSuccess(tUser));
      return ProfileCubit(GetProfileUseCase(mockRepo));
    },
    act: (c) => c.loadProfile(),
    expect: () => [isA<ProfileLoaded>().having((s) => s.user, 'user', tUser)],
  );

  blocTest<ProfileCubit, ProfileState>(
    'loadProfile emits ProfileError on failure',
    build: () {
      when(() => mockRepo.getProfile())
          .thenReturn(const ApiFailure(CacheFailure('missing')));
      return ProfileCubit(GetProfileUseCase(mockRepo));
    },
    act: (c) => c.loadProfile(),
    expect: () => [isA<ProfileError>().having((s) => s.message, 'message', 'missing')],
  );
}
