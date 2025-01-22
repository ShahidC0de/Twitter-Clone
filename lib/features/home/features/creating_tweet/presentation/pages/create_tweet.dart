import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/rounded_small_button.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/core/entities/user_presentation_model.dart';

class CreateTweetPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetPage());
  const CreateTweetPage({super.key});

  @override
  State<CreateTweetPage> createState() => _CreateTweetPageState();
}

class _CreateTweetPageState extends State<CreateTweetPage> {
  UserPresentationModel getCurrentUserData() {
    final blocProvider = BlocProvider.of<HomeBloc>(context);
    final state = blocProvider.state;
    if (state is HomeCurrentUserDataFetched) {
      return state.userData;
    } else {
      return UserPresentationModel(
        uid: '',
        name: '',
        email: '',
        followers: [],
        following: [],
        profilePic: '',
        bannerPic: '',
        bio: '',
        isTwitterBlue: false,
      );
    }
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
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [CircleAvatar()],
            )
          ],
        ),
      )),
    );
  }
}
