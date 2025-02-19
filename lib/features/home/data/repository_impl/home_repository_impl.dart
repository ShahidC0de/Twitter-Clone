import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/local_data_source/home_local_data_source.dart';
import 'package:twitter_clone/features/home/data/remote_data_source/home_remote_data_source.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  HomeRepositoryImpl({
    required HomeLocalDataSource homeLocalDataSource,
    required HomeRemoteDataSource homeRemoteDataSource,
  }) : _homeRemoteDataSource = homeRemoteDataSource;

  @override
  FutureEither<List<Tweet>> getAllTweets() async {
    try {
      final response = await _homeRemoteDataSource.getAllTweets();
      // storing these tweets in local storage is left to do.....
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither shareTweet(Tweet tweet) async {
    try {
      final response =
          await _homeRemoteDataSource.createTweet(tweet.toTweetModel());

      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<UserEntity> getUserData(String userId) async {
    try {
      final response = await _homeRemoteDataSource.getUserData(userId);
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEitherVoid likeTweet(Tweet tweet, String currentUserId) async {
    try {
      return right(await _homeRemoteDataSource.likeTweet(
          tweet.toTweetModel(), currentUserId));
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<Tweet> reshareTweet(Tweet tweet, String currentUser) async {
    try {
      await _homeRemoteDataSource.updateReshareCount(tweet.toTweetModel());
      Tweet tweetGot = await _homeRemoteDataSource.reshareTweet(
          tweet.toTweetModel(), currentUser);
      return right(tweetGot);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<List<Tweet>> getCommentsOfTweet(String tweetId) async {
    try {
      final response =
          await _homeRemoteDataSource.getTweetCommentsORreplies(tweetId);
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
