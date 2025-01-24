// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
import 'package:twitter_clone/core/constants/ui_constants.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/cubits/current_user_data/current_user_data_cubit.dart';
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
      body: BlocListener<CurrentUserDataCubit, CurrentUserDataState>(
        listener: (context, state) {
          if (state is CurrentUserDataLoaded) {
            log(state.userData.uid);
          } else {
            log('state is not the desired one');
          }
        },
        child: IndexedStack(
          index: _page,
          children: UiConstants.bottomTapBarScreens,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final blocProvider = BlocProvider.of<AppUserCubit>(context);
          final providerState = blocProvider.state;
          if (providerState is AppUserLoggedIn) {
            context.read<HomeBloc>().add(
                HomeFetchCurrentUserDataEvent(userId: providerState.user.id));
            Navigator.push(context, CreateTweetPage.route());
          }
        },
        child: const Icon(Icons.add),
      ), // a widget that maintain its state,
      // e.g: we scrolled a little while and then we navigated to search screen,
      // so if we return back we will found the screen on the same state we left:
    );
  }
}
