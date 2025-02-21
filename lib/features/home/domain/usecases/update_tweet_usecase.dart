import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class UpdateTweetUsecase implements Usecase<Tweet, UpdataTweetParams> {
  final HomeRepository _homeRepository;
  UpdateTweetUsecase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEither<Tweet> call(UpdataTweetParams params) async {
    return _homeRepository.updateTweet(params.tweet);
  }
}

class UpdataTweetParams {
  final Tweet tweet;
  UpdataTweetParams({
    required this.tweet,
  });
}
