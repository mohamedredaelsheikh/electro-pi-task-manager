import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_result.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;

  ProfileCubit(this._getProfile) : super(const ProfileInitial());

  void loadProfile() {
    final result = _getProfile();
    switch (result) {
      case ApiSuccess(:final data):
        emit(ProfileLoaded(data));
      case ApiFailure(:final failure):
        emit(ProfileError(failure.message));
    }
  }
}
