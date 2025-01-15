import 'package:twitter_clone/features/home/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
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
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? bio,
    String? isTwitterBlue,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      bio: bio ?? this.bio,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'uid': uid});
    result.addAll({'name': name});

    result.addAll({'email': email});

    result.addAll({'followers': followers});

    result.addAll({'following': following});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bannerPic': bannerPic});
    result.addAll({'bio': bio});
    result.addAll({'isTwitterBlue': isTwitterBlue});
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      followers: map['followers'],
      following: map['following'],
      profilePic: map['profilePic'],
      bannerPic: map['bannerPic'],
      bio: map['bio'],
      isTwitterBlue: map['isTwitterBlue'],
    );
  }
}
