part of 'user_profile_bloc.dart';

class UserProfileState {
  final bool isLoading;
  final String? errorMessage;
  final List<Tweet> userTweets;
  UserProfileState({
    required this.isLoading,
    this.errorMessage,
    required this.userTweets,
  });
  UserProfileState copyWith({
    bool? isLoading,
    List<Tweet>? userTweets,
    String? errorMessage,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      userTweets: userTweets ?? this.userTweets,
    );
  }
}

final class UserProfileInitial extends UserProfileState {
  UserProfileInitial() : super(isLoading: false, userTweets: const []);
}
