import 'package:flutter/material.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/features/user_profile/presentation/widgets/user_profile_item.dart';

class UserProfileScreen extends StatelessWidget {
  static route(UserEntity user) => MaterialPageRoute(
      builder: (context) => UserProfileScreen(userEntity: user));
  final UserEntity userEntity;
  const UserProfileScreen({
    super.key,
    required this.userEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserProfileItem(user: userEntity));
  }
}
