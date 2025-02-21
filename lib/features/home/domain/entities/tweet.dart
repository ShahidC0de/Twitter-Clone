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
  final String retweetedBy;
  final String repliedTo;

  const Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageList,
    required this.userId,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.tweetId,
    required this.reshareCount,
    required this.retweetedBy,
    required this.repliedTo,
  });
  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageList,
    String? userId,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? tweetId,
    int? reshareCount,
    String? retweetedBy,
    String? repliedTo,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageList: imageList ?? this.imageList,
      userId: userId ?? this.userId,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      tweetId: tweetId ?? this.tweetId,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }
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
      reshareCount: reshareCount,
      retweetedBy: retweetedBy,
      repliedTo: repliedTo,
    );
  }
}
