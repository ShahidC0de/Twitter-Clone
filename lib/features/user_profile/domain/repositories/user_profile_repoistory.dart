import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';

abstract interface class UserProfileRepoistory {
  FutureEither<List<Tweetmodel>> getUserTweets(String userId);
}
