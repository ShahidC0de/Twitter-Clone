import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';
import 'package:twitter_clone/features/home/presentation/widgets/tweet_card.dart';

/// Home UI Constants for Bottom Navigation Bar
class HomeUIConstants {
  static List<Widget> bottomTapBarScreens = [
    const TweetList(),
    const Text('Search Screen'),
    const Text('Notification Screen'),
  ];
}

class TweetList extends StatefulWidget {
  const TweetList({super.key});

  @override
  State<TweetList> createState() => _TweetListState();
}

class _TweetListState extends State<TweetList> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchAllTweets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
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
          return ListView.builder(
            itemCount: state.tweets.length,
            itemBuilder: (BuildContext context, index) {
              final tweet = state.tweets[index];
              return TweetCard(tweet: tweet);
            },
          );
        }
      },
    );
  }
}
