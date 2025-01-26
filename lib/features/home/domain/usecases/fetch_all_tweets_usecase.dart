import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class FetchAllTweetsUsecase implements Usecase<List<Tweet>, NoParams> {
  final HomeRepository _homeRepository;
  FetchAllTweetsUsecase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEither<List<Tweet>> call(NoParams params) async {
    return await _homeRepository.getAllTweets();
  }
}
