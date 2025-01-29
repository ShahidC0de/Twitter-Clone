import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/common/rounded_small_button.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/screens/home.dart';

class CreateTweetPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetPage());
  const CreateTweetPage({super.key});

  @override
  State<CreateTweetPage> createState() => _CreateTweetPageState();
}

class _CreateTweetPageState extends State<CreateTweetPage> {
  late UserEntity userData = UserEntity(
      uid: 'uid',
      name: 'name',
      email: 'email',
      followers: [],
      following: [],
      profilePic: 'profilePic',
      bannerPic: 'bannerPic',
      bio: 'bio',
      isTwitterBlue: false);
  List<File> pickedImages = [];
  final TextEditingController tweetController = TextEditingController();

  void onPickImages() async {
    pickedImages = await pickImages();
    setState(() {});
  }

  @override
  void dispose() {
    tweetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final blocProvider = BlocProvider.of<AppUserCubit>(context);
    final state = blocProvider.state;
    if (state is AppUserLoggedIn) {
      userData = state.user;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RoundedSmallButton(
            onTap: () {
              if (tweetController.text.isNotEmpty || pickedImages.isNotEmpty) {
                context.read<HomeBloc>().add(ShareTweet(
                      userId: userData.uid,
                      tweetText: tweetController.text,
                      tweetImages:
                          pickedImages.map((image) => image.path).toList(),
                    ));
              } else {
                showSnackBar(context, "An empty tweet can't be tweeted");
              }

              log('button Clicked');
            },
            label: 'Create',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              size: 30,
            )),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            showSnackBar(context, 'something bad happend');
          } else if (state is ShareTweetSucceed) {
            Navigator.pushAndRemoveUntil(
                context, Home.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is ShareTweetLoading) {
            return const Loader();
          }
          return SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: userData.profilePic.isNotEmpty
                          ? NetworkImage(userData.profilePic)
                          : null,
                      radius: 30,
                      child: userData.profilePic.isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: tweetController,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                        decoration: const InputDecoration(
                          hintText: "What's happening?",
                          hintStyle: TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
                CarouselSlider(
                    items: pickedImages
                        .map((image) => Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Image.file(image)))
                        .toList(),
                    options: CarouselOptions(
                      height: 400,
                      enableInfiniteScroll: false,
                    ))
              ],
            ),
          ));
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(color: Pallete.greyColor, width: 0.3))),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(
            left: 15,
            right: 15,
          ),
          child: Row(
            spacing: 10.0,
            children: [
              GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                  semanticsLabel: 'Open gallery to pick images',
                ),
              ),
              SvgPicture.asset(
                AssetsConstants.gifIcon,
              ),
              SvgPicture.asset(
                AssetsConstants.emojiIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
