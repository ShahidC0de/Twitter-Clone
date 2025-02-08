import 'dart:developer';

import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';

class Tweetmodel extends Tweet {
  const Tweetmodel(
      {required super.text,
      required super.hashtags,
      required super.link,
      required super.imageList,
      required super.userId,
      required super.tweetType,
      required super.tweetedAt,
      required super.likes,
      required super.commentIds,
      required super.tweetId,
      required super.reshareCount,
      required super.retweetedBy});
  // to map function
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageList': imageList,
      'userId': userId,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'reshareCount': reshareCount,
      'tweetId': tweetId,
    };
  }

  // from Map
  factory Tweetmodel.fromMap(Map<String, dynamic> map) {
    log("Raw data from Firestore: $map"); // Log the map
    return Tweetmodel(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags'] as List? ?? []),
      link: map['link'] ?? '',
      imageList: List<String>.from(map['imageList'] as List? ?? []),
      userId: map['userId'] ?? '',
      tweetType:
          (map['tweetType'] as String?)?.toTweetTypeEnum() ?? TweetType.text,
      tweetedAt: map['tweetedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int)
          : DateTime.now(),
      likes: List<String>.from(map['likes'] as List? ?? []),
      commentIds: List<String>.from(map['commentIds'] as List? ?? []),
      tweetId: map['tweetId'] as String? ?? '',
      reshareCount: map['reshareCount'] as int? ?? 0,
      retweetedBy: map['retweetedBy'] ?? '',
    );
  }

  Tweetmodel copyWith({
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
  }) {
    return Tweetmodel(
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
    );
  }
}
