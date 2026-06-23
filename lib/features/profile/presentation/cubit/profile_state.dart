import '../../../auth/domain/entities/user.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoaded extends ProfileState {
  final User user;
  const ProfileLoaded(this.user);
}

final class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
