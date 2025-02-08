import 'dart:developer';

import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';
import 'package:twitter_clone/features/home/domain/usecases/tweet_parser.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';

class CreateTweetUsecase implements Usecase<void, CreateTweetParams> {
  final HomeRepository _homeRepository;
  final TweetParser _tweetParser;

  CreateTweetUsecase({
    required HomeRepository homeRepository,
    required TweetParser tweetParser,
  })  : _homeRepository = homeRepository,
        _tweetParser = tweetParser;

  @override
  FutureEither<void> call(CreateTweetParams params) async {
    log('i am in createtweetusecase');
    final hashTags = _tweetParser.getHashTagsFromText(params.tweetText);
    final link = _tweetParser.getLinkFromTheText(params.tweetText);
    Tweet tweet = Tweet(
      text: params.tweetText,
      hashtags: hashTags,
      link: link,
      imageList: params.tweetImages,
      userId: params.userId,
      tweetType: params.tweetImages.isEmpty ? TweetType.text : TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      tweetId: DateTime.now().millisecondsSinceEpoch.toString(),
      reshareCount: 0,
      retweetedBy: '',
    );
    return await _homeRepository.shareTweet(tweet);
  }
}

class CreateTweetParams {
  final String userId;
  final String tweetText;
  final List<String> tweetImages;
  CreateTweetParams({
    required this.userId,
    required this.tweetText,
    required this.tweetImages,
  });
}
