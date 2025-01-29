import 'package:twitter_clone/features/home/data/models/user_model.dart';

class UserEntity {
  final String uid;
  final String name;
  final String email;
  final List<dynamic> followers;
  final List<dynamic> following;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final bool isTwitterBlue;

  UserEntity({
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
  bool isEmpty() {
    return uid.isEmpty &&
        name.isEmpty &&
        email.isEmpty &&
        followers.isEmpty &&
        following.isEmpty &&
        profilePic.isEmpty &&
        bannerPic.isEmpty &&
        bio.isEmpty;
  }

  bool get isNotEmpty => !isEmpty();
}

extension UserEntityMapper on UserEntity {
  UserModel toUserModel() {
    return UserModel(
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
