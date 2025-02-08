import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class ReshareTweetUsecase implements Usecase<Tweet, ReshareTweetParams> {
  final HomeRepository _homeRepository;
  ReshareTweetUsecase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEither<Tweet> call(ReshareTweetParams params) {
    return _homeRepository.reshareTweet(params.tweet, params.currentUserId);
  }
}

class ReshareTweetParams {
  final Tweet tweet;
  final String currentUserId;
  ReshareTweetParams({
    required this.tweet,
    required this.currentUserId,
  });
}
