// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
import 'package:twitter_clone/core/theme/pallete.dart';

class UiConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTapBarScreens = [
    Text('Feed Screen'),
    Text('Search Screen'),
    Text('Notfication Screen'),
  ];
}
