// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
import 'package:twitter_clone/core/constants/ui_constants.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/presentation/pages/create_tweet.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';

class Home extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Home());

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  final appBar = UiConstants.appBar();
  void onPageClick(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
    context.read<HomeBloc>().add(
        HomeFetchCurrentUserDataEvent(userId: ' Z1wOtrZTuQbCZ3To3RucTz0Bpco2'));
    log('hi i am in init state');
    // final blocProvider = BlocProvider.of<AppUserCubit>(context);
    // final someState = blocProvider.state;
    // if (someState is AppUserLoggedIn) {
    //   final userId = someState.user.id;

    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Pallete.backgroundColor,
          currentIndex: _page,
          onTap: onPageClick,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              color: Pallete.whiteColor,
            )),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: Pallete.whiteColor,
            )),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              color: Pallete.whiteColor,
            )),
          ]),
      body: IndexedStack(
        index: _page,
        children: UiConstants.bottomTapBarScreens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CreateTweetPage.route());
        },
        child: const Icon(Icons.add),
      ), // a widget that maintain its state,
      // e.g: we scrolled a little while and then we navigated to search screen,
      // so if we return back we will found the screen on the same state we left:
    );
  }
}
