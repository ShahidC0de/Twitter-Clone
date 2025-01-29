import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';

class HomeUIConstants<String> {
  static List<Widget> bottomTapBarScreens = [
    const TweetList(),
    const Text('Search Screen'),
    const Text('Notfication Screen'),
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
    context.read<HomeBloc>().add(FetchAllTweets());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeFailure) {
          showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is FetchingTweetsLoading) {
          return const Loader();
        } else if (state is FetchingTweetsSuccess) {
          final tweets = state.tweets;

          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (BuildContext context, index) {
              final tweet = tweets[index];
              return Text(tweet.text);
            },
          );
        }
        return const SizedBox(
          child: Text('No data'),
        );
      },
    );
  }
}
