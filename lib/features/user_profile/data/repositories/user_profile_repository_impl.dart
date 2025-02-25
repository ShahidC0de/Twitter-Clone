import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/common/storage_data_source/storage_remote_data_source.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/models/user_model.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';
import 'package:twitter_clone/features/user_profile/data/data_source/user_profile_remote_data_source.dart';
import 'package:twitter_clone/features/user_profile/domain/repositories/user_profile_repoistory.dart';

class UserProfileRepositoryImpl implements UserProfileRepoistory {
  final UserProfileRemoteDataSource _userProfileRemoteDataSource;
  final StorageRemoteDataSource _storageRemoteDataSource;
  UserProfileRepositoryImpl({
    required StorageRemoteDataSource storageRemoteDatasource,
    required UserProfileRemoteDataSource userProfileRemoteDataSource,
  })  : _userProfileRemoteDataSource = userProfileRemoteDataSource,
        _storageRemoteDataSource = storageRemoteDatasource;
  @override
  FutureEither<List<Tweetmodel>> getUserTweets(String userId) async {
    try {
      final response = await _userProfileRemoteDataSource.getUserTweets(userId);
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }

  @override
  FutureEitherVoid updateUserData(
      UserEntity user, File? bannerFile, File? profileFile) async {
    try {
      UserModel userData = user.toUserModel();
      if (bannerFile != null) {
        final bannerPic = await _storageRemoteDataSource.storeListOfImages(
            [bannerFile.path], '${user.uid + bannerFile.path} updated');
        userData = userData.copyWith(
          bannerPic: bannerPic[0],
        );
      }
      if (profileFile != null) {
        final profileUrl = await _storageRemoteDataSource.storeListOfImages(
            [profileFile.path], '${user.uid + profileFile.path} updated');
        userData = userData.copyWith(
          profilePic: profileUrl[0],
        );
      }
      final response = _userProfileRemoteDataSource.updateUserData(userData);
      return right(response);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
