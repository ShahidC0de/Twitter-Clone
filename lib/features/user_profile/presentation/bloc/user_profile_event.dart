part of 'user_profile_bloc.dart';

sealed class UserProfileEvent {}

class GetUserTweetsEvent extends UserProfileEvent {
  final String userId;
  GetUserTweetsEvent({
    required this.userId,
  });
}

class UpdateUserDataEvent extends UserProfileEvent {
  final UserEntity user;
  final File? bannerFile;
  final File? profileFile;
  UpdateUserDataEvent({
    required this.user,
    required this.bannerFile,
    required this.profileFile,
  });
}
