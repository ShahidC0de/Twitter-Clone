import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/user_profile/presentation/bloc/user_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileScreen());
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? bannerPic;
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  File? bannerFile;
  File? profileFile;
  UserEntity? currentUser;
  void selectingBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectingProfilePic() async {
    final profilePic = await pickImage();
    if (profilePic != null) {
      setState(() {
        profileFile = profilePic;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AppUserCubit>(context);
    final state = blocProvider.state;
    currentUser = (state is AppUserLoggedIn) ? currentUser = state.user : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                context.read<UserProfileBloc>().add(UpdateUserDataEvent(
                    user: UserEntity(
                        uid: currentUser!.uid,
                        name: nameController.text.isNotEmpty
                            ? nameController.text
                            : currentUser!.name,
                        email: currentUser!.email,
                        followers: currentUser!.followers,
                        following: currentUser!.following,
                        profilePic: currentUser!.profilePic,
                        bannerPic: currentUser!.bannerPic,
                        bio: bioController.text.isNotEmpty
                            ? bioController.text
                            : currentUser!.bio,
                        isTwitterBlue: currentUser!.isTwitterBlue),
                    bannerFile: bannerFile,
                    profileFile: profileFile));
                setState(() {});
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Pallete.blueColor,
                ),
              ))
        ],
      ),
      body: currentUser == null
          ? const Loader()
          : BlocListener<UserProfileBloc, UserProfileState>(
              listener: (context, state) {
                if (state.isLoading == true) {
                  const Loader();
                } else if (state.errorMessage != null) {
                  showSnackBar(context, state.errorMessage!);
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(children: [
                      GestureDetector(
                        onTap: selectingBannerImage,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            height: 150,
                            child: bannerFile != null
                                ? Image.file(
                                    bannerFile!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : currentUser!.bannerPic.isEmpty
                                    ? Container(
                                        color: Pallete.blueColor,
                                      )
                                    : Image.network(
                                        currentUser!.bannerPic,
                                        fit: BoxFit.fitWidth,
                                      )),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectingProfilePic,
                          child: profileFile != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(profileFile!),
                                  radius: 45,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    currentUser!.profilePic,
                                  ),
                                  radius: 45,
                                ),
                        ),
                      ),
                    ]),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: currentUser!.name,
                      contentPadding: const EdgeInsets.all(18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      hintText: currentUser!.bio,
                      contentPadding: const EdgeInsets.all(18),
                    ),
                    maxLines: 4,
                  )
                ],
              ),
            ),
    );
  }
}
