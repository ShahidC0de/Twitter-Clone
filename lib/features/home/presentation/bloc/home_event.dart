part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class FetchAllTweets extends HomeEvent {}

class ShareTweet extends HomeEvent {
  final String userId;
  final String tweetText;
  final List<String> imagesList;
  ShareTweet({
    required this.userId,
    required this.tweetText,
    required this.imagesList,
  });
}

class GetUser extends HomeEvent {
  final String userId;
  GetUser({required this.userId});
}
