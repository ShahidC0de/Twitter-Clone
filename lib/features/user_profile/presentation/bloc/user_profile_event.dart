part of 'user_profile_bloc.dart';

sealed class UserProfileEvent {}

class GetUserTweetsEvent extends UserProfileEvent {
  final String userId;
  GetUserTweetsEvent({
    required this.userId,
  });
}
