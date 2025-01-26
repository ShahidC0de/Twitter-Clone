import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/core/utils/tweet_parser.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/domain/repository/create_tweet_repository.dart';

class CreateTweetUsecase implements Usecase<void, CreateTweetParams> {
  final CreateTweetRepository _createTweetRepository;
  final TweetParser _tweetParser;

  CreateTweetUsecase({
    required CreateTweetRepository createTweetRepository,
    required TweetParser tweetParser,
  })  : _createTweetRepository = createTweetRepository,
        _tweetParser = tweetParser;

  @override
  FutureEither<void> call(CreateTweetParams params) async {
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
    );
    return await _createTweetRepository.createTweet(tweet);
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
