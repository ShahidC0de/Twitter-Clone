import 'package:fpdart/fpdart.dart';
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
          await _homeRemoteDataSource.shareTweet(tweet.toTweetModel());

      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
