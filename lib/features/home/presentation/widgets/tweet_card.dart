import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter_clone/features/home/presentation/widgets/hashtage_widget.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final userEntity = state.users[tweet.userId];

        if (userEntity == null) {
          context.read<HomeBloc>().add(GetUser(userId: tweet.userId));
          return const Loader();
        }

        return Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userEntity.profilePic),
                    radius: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // retweeted thing...
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Text(
                              userEntity.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '@${userEntity.name}  ${timeago.format(
                              tweet.tweetedAt,
                              locale: 'en_short',
                            )}',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Pallete.greyColor,
                            ),
                          ),
                        ],
                      ),
                      // replied to
                      HashtageWidget(text: tweet.text),
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
