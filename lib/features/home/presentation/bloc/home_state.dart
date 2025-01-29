part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

// FETCHING TWEETS STATES;
final class FetchingTweetsSuccess extends HomeState {
  final List<Tweet> tweets;
  FetchingTweetsSuccess({
    required this.tweets,
  });
}

final class FetchingTweetsLoading extends HomeState {}

final class HomeFailure extends HomeState {
  final String message;
  HomeFailure({required this.message});
}

// CREATING TWEET STATES;
final class ShareTweetLoading extends HomeState {}

final class ShareTweetSucceed extends HomeState {}
