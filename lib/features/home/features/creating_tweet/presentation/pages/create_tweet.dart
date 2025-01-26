import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/common/rounded_small_button.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
import 'package:twitter_clone/core/cubits/current_user_data/current_user_data_cubit.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/core/entities/user_presentation_model.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/presentation/bloc/create_tweet_bloc.dart';
import 'package:twitter_clone/features/home/presentation/screens/home.dart';

class CreateTweetPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetPage());
  const CreateTweetPage({super.key});

  @override
  State<CreateTweetPage> createState() => _CreateTweetPageState();
}

class _CreateTweetPageState extends State<CreateTweetPage> {
  List<File> pickedImages = [];
  final TextEditingController tweetController = TextEditingController();

  UserPresentationModel? userData;
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
                context.read<CreateTweetBloc>().add(CreateUserTweetEvent(
                      userId: userData!.uid,
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
      body: BlocConsumer<CreateTweetBloc, CreateTweetState>(
        listener: (context, state) {
          if (state is CreateTweetFailure) {
            showSnackBar(context, 'something bad happend');
          } else if (state is CreateTweetSuccess) {
            Navigator.pushAndRemoveUntil(
                context, Home.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is CreatingTweetLoading) {
            return const Loader();
          }
          return BlocListener<CurrentUserDataCubit, CurrentUserDataState>(
            listener: (context, state) {
              if (state is CurrentUserDataLoaded) {
                setState(() {
                  userData = state.userData;
                });
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
                        radius: 30,
                        child: userData == null || userData!.profilePic.isEmpty
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
            )),
          );
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
