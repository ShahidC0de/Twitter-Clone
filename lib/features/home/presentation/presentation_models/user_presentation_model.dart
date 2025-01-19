import 'package:twitter_clone/features/home/domain/entities/user_entity.dart';

class UserPresentationModel extends UserEntity {
  UserPresentationModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.followers,
    required super.following,
    required super.profilePic,
    required super.bannerPic,
    required super.bio,
    required super.isTwitterBlue,
  });
}

extension UserEntityMapper on UserEntity {
  UserPresentationModel toPresentationModel() {
    return UserPresentationModel(
        uid: uid,
        name: name,
        email: email,
        followers: followers,
        following: following,
        profilePic: profilePic,
        bannerPic: bannerPic,
        bio: bio,
        isTwitterBlue: isTwitterBlue);
  }
}
