import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/rounded_small_button.dart';
import 'package:twitter_clone/core/cubits/current_user_data/current_user_data_cubit.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/core/entities/user_presentation_model.dart';

class CreateTweetPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetPage());
  const CreateTweetPage({super.key});

  @override
  State<CreateTweetPage> createState() => _CreateTweetPageState();
}

class _CreateTweetPageState extends State<CreateTweetPage> {
  UserPresentationModel? userData;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RoundedSmallButton(
            onTap: () {},
            label: 'Create',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.close,
              size: 30,
            )),
      ),
      body: BlocListener<CurrentUserDataCubit, CurrentUserDataState>(
        listener: (context, state) {
          if (state is CurrentUserDataLoaded) {
            setState(() {
              userData = state.userData;
            });
            print("User Data is ${userData!.profilePic}");
          }
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        userData != null && userData!.profilePic.isNotEmpty
                            ? NetworkImage(userData!.profilePic)
                            : null,
                    child: userData == null || userData!.profilePic.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
