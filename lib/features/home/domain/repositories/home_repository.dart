import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';

abstract interface class HomeRepository {
  FutureEither<List<Tweet>> getAllTweets();
  FutureEither shareTweet(Tweet tweet);
}
