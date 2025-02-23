import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';

class EditProfileScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileScreen());
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserEntity? currentUser;

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AppUserCubit>(context);
    final state = blocProvider.state;
    currentUser = (state is AppUserLoggedIn) ? currentUser = state.user : null;
    return Scaffold(
      body: currentUser == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(children: [
                    Positioned.fill(
                        child: currentUser!.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(currentUser!.bannerPic)),
                    Positioned(
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          currentUser!.profilePic,
                        ),
                        radius: 45,
                      ),
                    ),
                  ]),
                )
              ],
            ),
    );
  }
}
