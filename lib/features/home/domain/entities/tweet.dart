import 'package:flutter/cupertino.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageList;
  final String userId;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String tweetId;
  final int reshareCount;

  const Tweet(
      {required this.text,
      required this.hashtags,
      required this.link,
      required this.imageList,
      required this.userId,
      required this.tweetType,
      required this.tweetedAt,
      required this.likes,
      required this.commentIds,
      required this.tweetId,
      required this.reshareCount});
  // to map functionality
}

extension TweetMapper on Tweet {
  Tweetmodel toTweetModel() {
    return Tweetmodel(
        text: text,
        hashtags: hashtags,
        link: link,
        imageList: imageList,
        userId: userId,
        tweetType: tweetType,
        tweetedAt: tweetedAt,
        likes: likes,
        commentIds: commentIds,
        tweetId: tweetId,
        reshareCount: reshareCount);
  }
}
