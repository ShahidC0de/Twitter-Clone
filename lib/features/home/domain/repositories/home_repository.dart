import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/entities/user_entity.dart';

abstract interface class HomeRepository {
  FutureEither<UserEntity> getCurrentUserData(final String userId);
  FutureEither<List<Tweet>> getAllTweets();
}
