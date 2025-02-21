import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';

abstract interface class HomeRepository {
  FutureEither<List<Tweet>> getAllTweets();
  FutureEither shareTweet(Tweet tweet);
  FutureEither<UserEntity> getUserData(String userId);
  FutureEitherVoid likeTweet(Tweet tweet, String currentUserId);
  FutureEither<Tweet> reshareTweet(Tweet tweet, String currentUser);
  FutureEither<List<Tweet>> getCommentsOfTweet(String tweetId);
  FutureEither<Tweet> updateTweet(Tweet tweet);
}
