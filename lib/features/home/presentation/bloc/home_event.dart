part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class FetchAllTweets extends HomeEvent {}

final class ShareTweet extends HomeEvent {
  final String userId;
  final String tweetText;
  final List<String> tweetImages;
  ShareTweet({
    required this.userId,
    required this.tweetText,
    required this.tweetImages,
  });
}
