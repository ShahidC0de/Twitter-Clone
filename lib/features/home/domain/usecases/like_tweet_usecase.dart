import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class LikeTweetUsecase implements Usecase<void, LikeTweetParams> {
  final HomeRepository _homeRepository;
  LikeTweetUsecase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEither<void> call(LikeTweetParams params) async {
    return _homeRepository.likeTweet(params.tweet, params.currentUserId);
  }
}

class LikeTweetParams {
  final Tweet tweet;
  final String currentUserId;
  LikeTweetParams({
    required this.tweet,
    required this.currentUserId,
  });
}
