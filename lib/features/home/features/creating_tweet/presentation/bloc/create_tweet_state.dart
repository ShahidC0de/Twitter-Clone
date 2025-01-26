part of 'create_tweet_bloc.dart';

@immutable
sealed class CreateTweetState {}

final class CreateTweetInitial extends CreateTweetState {}

final class CreatingTweetLoading extends CreateTweetState {}

final class CreateTweetSuccess extends CreateTweetState {}

final class CreateTweetFailure extends CreateTweetState {
  final String message;
  CreateTweetFailure({required this.message});
}
