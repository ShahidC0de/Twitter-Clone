import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/theme/theme.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';
import 'package:twitter_clone/features/home/presentation/widgets/tweet_card.dart';

class TweetCommentScreen extends StatefulWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => TweetCommentScreen(tweet: tweet));
  final Tweet tweet;
  const TweetCommentScreen({super.key, required this.tweet});

  @override
  State<TweetCommentScreen> createState() => _TweetCommentScreenState();
}

class _TweetCommentScreenState extends State<TweetCommentScreen> {
  @override
  void initState() {
    context
        .read<HomeBloc>()
        .add(FetchCommentsTweetsEvent(tweetId: widget.tweet.tweetId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tweet'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TweetCard(tweet: widget.tweet),
          const Text(
            'Comments',
            style: TextStyle(
              color: Pallete.greyColor,
              fontSize: 16,
            ),
          ),
          BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                showSnackBar(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const Loader();
              } else if (state.tweets.isEmpty) {
                return const Center(
                  child: Text('No Tweets Found'),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.tweetComments.length,
                    itemBuilder: (BuildContext context, index) {
                      final tweet = state.tweetComments[index];
                      return TweetCard(tweet: tweet);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          final state = BlocProvider.of<AppUserCubit>(context).state;
          if (state is AppUserLoggedIn) {
            final userId = state.user.uid;
            log('i am in comment screen and the tweetId is ${widget.tweet.tweetId}');
            context.read<HomeBloc>().add(ShareTweet(
                  userId: userId,
                  tweetText: value,
                  imagesList: const [],
                  repliedTo: widget.tweet.tweetId,
                ));
            final Tweet updatedTweet = widget.tweet
                .copyWith(commentIds: [...widget.tweet.commentIds, userId]);
            context.read<HomeBloc>().add(UpdateTweetEvent(tweet: updatedTweet));
          }
        },
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
      ),
    );
  }
}
