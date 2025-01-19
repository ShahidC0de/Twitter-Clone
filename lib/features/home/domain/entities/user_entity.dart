class UserEntity {
  final String uid;
  final String name;
  final String email;
  final List<dynamic> followers;
  final List<dynamic> following;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final String isTwitterBlue;

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
}
