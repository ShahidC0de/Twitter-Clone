part of 'create_tweet_bloc.dart';

@immutable
sealed class CreateTweetEvent {}

final class CreateUserTweetEvent extends CreateTweetEvent {
  final String userId;
  final String tweetText;
  final List<String> tweetImages;
  CreateUserTweetEvent({
    required this.userId,
    required this.tweetText,
    required this.tweetImages,
  });
}
