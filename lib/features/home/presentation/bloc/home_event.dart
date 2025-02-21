part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchAllTweets extends HomeEvent {}

class ShareTweet extends HomeEvent {
  final String userId;
  final String tweetText;
  final List<String> imagesList;
  final String? repliedTo;
  ShareTweet({
    required this.userId,
    required this.tweetText,
    required this.imagesList,
    this.repliedTo,
  });
}

class GetUser extends HomeEvent {
  final String userId;
  GetUser({required this.userId});
}

class LikeTweet extends HomeEvent {
  final Tweet tweet;
  final String currentUserId;
  LikeTweet({
    required this.tweet,
    required this.currentUserId,
  });
}

class ReshareTweet extends HomeEvent {
  final Tweet tweet;
  final String currentUserId;
  ReshareTweet({
    required this.tweet,
    required this.currentUserId,
  });
}

class FetchCommentsTweetsEvent extends HomeEvent {
  final String tweetId;
  FetchCommentsTweetsEvent({
    required this.tweetId,
  });
}

class UpdateTweetEvent extends HomeEvent {
  final Tweet tweet;
  UpdateTweetEvent({
    required this.tweet,
  });
}
