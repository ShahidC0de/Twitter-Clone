import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class FetchCommentsTweetsUsecase
    implements Usecase<List<Tweet>, FetchCommentsTweetsParams> {
  final HomeRepository _homeRepository;
  FetchCommentsTweetsUsecase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEither<List<Tweet>> call(FetchCommentsTweetsParams params) {
    return _homeRepository.getCommentsOfTweet(params.tweetId);
  }
}

class FetchCommentsTweetsParams {
  final String tweetId;
  FetchCommentsTweetsParams({
    required this.tweetId,
  });
}
