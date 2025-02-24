import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/core/utils/utilities.dart';

class EditProfileScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileScreen());
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<File> pickedImages = [];
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  UserEntity? currentUser;
  void onPickImage() async {
    pickedImages = await pickImages();
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
              onPressed: () {},
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
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        height: 150,
                        child: currentUser!.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(currentUser!.bannerPic)),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          currentUser!.profilePic,
                        ),
                        radius: 45,
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
                  maxLength: 4,
                )
              ],
            ),
    );
  }
}
