import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';

abstract interface class CreateTweetRepository {
  FutureEither createTweet(Tweet tweet);
}
