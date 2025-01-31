import 'package:flutter/material.dart';
import 'package:twitter_clone/core/theme/pallete.dart';

class HashtageWidget extends StatelessWidget {
  final String text;
  const HashtageWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )));
      } else if (element.startsWith('wwww.') ||
          element.startsWith('https://')) {
        textspans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            )));
      } else {
        textspans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
            )));
      }
    });
    return RichText(
        text: TextSpan(
      children: textspans,
    ));
  }
}
