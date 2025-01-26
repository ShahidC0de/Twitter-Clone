import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/local_data_source/home_local_data_source.dart';
import 'package:twitter_clone/features/home/data/remote_data_source/home_remote_data_source.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  final HomeLocalDataSource _homeLocalDataSource;
  HomeRepositoryImpl({
    required HomeLocalDataSource homeLocalDataSource,
    required HomeRemoteDataSource homeRemoteDataSource,
  })  : _homeRemoteDataSource = homeRemoteDataSource,
        _homeLocalDataSource = homeLocalDataSource;
  @override
  FutureEither<UserEntity> getCurrentUserData(String userId) async {
    try {
      final UserEntity userEntity =
          await _homeRemoteDataSource.getCurrentUserData(userId);
      bool rowsEffected = await _homeLocalDataSource
          .insertCurrentUserData(userEntity.toUserModel());
      log(rowsEffected.toString());

      return right(userEntity);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEither<List<Tweet>> getAllTweets() async {
    try {
      final response = await _homeRemoteDataSource.getAllTweets();
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
