import 'package:flutter/material.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/user_profile/presentation/screens/user_profile_screen.dart';

class SearchedUserTile extends StatelessWidget {
  final UserEntity userEntity;
  const SearchedUserTile({super.key, required this.userEntity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, UserProfileScreen.route(userEntity));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userEntity.profilePic, scale: 30),
      ),
      title: Text(
        userEntity.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userEntity.name}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            userEntity.bio,
            style: const TextStyle(
              fontSize: 16,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
