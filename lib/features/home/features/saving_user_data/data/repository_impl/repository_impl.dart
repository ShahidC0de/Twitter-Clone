import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/type_def/failure.dart';
import 'package:twitter_clone/features/home/data/models/user_model.dart';
import 'package:twitter_clone/features/home/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/home/features/saving_user_data/data/remote_data_source/saving_user_data_home_remote_data_source.dart';
import 'package:twitter_clone/features/home/features/saving_user_data/domain/repositories/respository.dart';

class SavingUserDataRepositoryImpl implements SavingUserDataRepository {
  final SavingUserDataSource _savingUserDataSource;
  SavingUserDataRepositoryImpl({
    required SavingUserDataSource savingUserDataSource,
  }) : _savingUserDataSource = savingUserDataSource;
  @override
  FutureEitherVoid saveUserData(UserEntity user) async {
    try {
      _savingUserDataSource.storeUserInfo(UserModel(
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
