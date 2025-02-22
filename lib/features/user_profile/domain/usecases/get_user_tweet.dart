import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';
import 'package:twitter_clone/features/user_profile/domain/repositories/user_profile_repoistory.dart';

class GetUserTweetUseCase
    implements Usecase<List<Tweetmodel>, GetUserTweetParams> {
  final UserProfileRepoistory _userProfileRepoistory;
  GetUserTweetUseCase({
    required UserProfileRepoistory userProfileRepository,
  }) : _userProfileRepoistory = userProfileRepository;
  @override
  FutureEither<List<Tweetmodel>> call(GetUserTweetParams params) async {
    return _userProfileRepoistory.getUserTweets(params.userId);
  }
}

class GetUserTweetParams {
  final String userId;
  GetUserTweetParams({
    required this.userId,
  });
}
