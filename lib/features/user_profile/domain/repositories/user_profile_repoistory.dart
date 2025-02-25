import 'dart:io';

import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';

abstract interface class UserProfileRepoistory {
  FutureEither<List<Tweetmodel>> getUserTweets(String userId);
  FutureEitherVoid updateUserData(
      UserEntity user, File? bannerFile, File? profileFile);
}
