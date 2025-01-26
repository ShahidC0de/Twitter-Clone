import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/data/remote_data_source/create_tweet_data_source.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/domain/repository/create_tweet_repository.dart';

class CreateTweetRepositoryImpl implements CreateTweetRepository {
  final CreateTweetRemoteDataSource _createTweetRemoteDataSource;
  CreateTweetRepositoryImpl({
    required CreateTweetRemoteDataSource createTweetRemoteDataSource,
  }) : _createTweetRemoteDataSource = createTweetRemoteDataSource;

  @override
  FutureEither<void> createTweet(Tweet tweet) async {
    try {
      log('i am in repository impl');
      final response = await _createTweetRemoteDataSource.shareTweet(
          tweetModel: tweet.toTweetModel());

      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
