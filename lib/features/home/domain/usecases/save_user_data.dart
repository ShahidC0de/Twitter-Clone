import 'package:twitter_clone/core/type_def/datatype.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/user.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';

class SaveUserDataUseCase implements Usecase<void, UserDataParams> {
  final HomeRepository _homeRepository;
  SaveUserDataUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;
  @override
  FutureEitherVoid call(UserDataParams params) {
    return _homeRepository.saveUserData(UserEntity(
      uid: params.uid,
      name: params.name,
      email: params.email,
      followers: params.followers,
      following: params.following,
      profilePic: params.profilePic,
      bannerPic: params.bannerPic,
      bio: params.bio,
      isTwitterBlue: params.isTwitterBlue,
    ));
  }
}

class UserDataParams {
  final String uid;
  final String name;
  final String email;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final String isTwitterBlue;
  UserDataParams({
    required this.uid,
    required this.name,
    required this.email,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.bio,
    required this.isTwitterBlue,
  });
}
