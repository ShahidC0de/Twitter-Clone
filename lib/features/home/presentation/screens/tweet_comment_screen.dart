import 'package:flutter/material.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/presentation/widgets/tweet_card.dart';

class TweetCommentScreen extends StatelessWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => TweetCommentScreen(tweet: tweet));
  final Tweet tweet;
  const TweetCommentScreen({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {},
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
      ),
    );
  }
}
