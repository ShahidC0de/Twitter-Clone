import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/domain/entities/tweet.dart';

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
      required super.reshareCount});
  // to map function
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags as List});
    result.addAll({'link': link});
    result.addAll({'imageList': imageList as List});
    result.addAll({'userId': userId});
    result.addAll({'tweetType': tweetType.type});
    result.addAll({'tweetAt': tweetedAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'commentIds': commentIds as List});
    result.addAll({'reshareCount': reshareCount});
    result.addAll({'tweetId': tweetId});
    return result;
  }

  // from Map
  factory Tweetmodel.fromMap(Map<String, dynamic> map) {
    return Tweetmodel(
        text: map['text'] ?? '',
        hashtags: List<String>.from(map['hashtags']),
        link: map['link'],
        imageList: List<String>.from(['imageList']),
        userId: map['userId'],
        tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
        tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt']),
        likes: List<String>.from(map['likes']),
        commentIds: List<String>.from(map['commentIds']),
        tweetId: map['tweetId'],
        reshareCount: map['reshareCount'] as int);
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
        reshareCount: reshareCount ?? this.reshareCount);
  }
}
