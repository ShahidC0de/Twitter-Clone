import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';
import 'package:twitter_clone/features/home/data/remote_data_source/home_remote_datasource_impl.dart';
import 'package:twitter_clone/features/home/domain/entities/user.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _homeRemoteDatasource;
  HomeRepositoryImpl({
    required HomeRemoteDatasource homeRemoteDatasource,
  }) : _homeRemoteDatasource = homeRemoteDatasource;
  @override
  FutureEitherVoid saveUserData(UserEntity user) async {
    try {
      _homeRemoteDatasource.storeUserInfo(UserModel(
        uid: user.uid,
        name: user.name,
        email: user.email,
        followers: user.followers,
        following: user.following,
        profilePic: user.profilePic,
        bannerPic: user.bannerPic,
        bio: user.bio,
        isTwitterBlue: user.isTwitterBlue,
      ));
      return right(null);
    } catch (e) {
      return left(Failure(e.toString(), StackTrace.current));
    }
  }
}
