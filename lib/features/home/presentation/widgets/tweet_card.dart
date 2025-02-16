import 'dart:developer';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter_clone/features/home/presentation/widgets/crousal_image.dart';
import 'package:twitter_clone/features/home/presentation/widgets/hashtage_widget.dart';
import 'package:twitter_clone/features/home/presentation/widgets/tweet_icon_button.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AppUserCubit>(context);
    final state = blocProvider.state;
    final String currentUserId =
        (state is AppUserLoggedIn) ? state.user.uid : '';

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tweetUser = state.users[tweet.userId];
        log('hello the request data for ${tweet.userId}');

        if (tweetUser == null) {
          if (tweet.retweetedBy.isNotEmpty) {
            context.read<HomeBloc>().add(GetUser(userId: tweet.retweetedBy));
          }
          context.read<HomeBloc>().add(GetUser(userId: tweet.userId));
          log('hello the request data for ${tweet.userId}');
          return const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Fetching user..."),
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(tweetUser.profilePic),
                    radius: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tweet.retweetedBy.isNotEmpty)
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsConstants.retweetIcon,
                              color: Pallete.greyColor,
                              height: 20,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                '${tweetUser.name} retweeted',
                                style: const TextStyle(
                                  color: Pallete.greyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Text(
                              tweetUser.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '@${tweetUser.name}  ${timeago.format(
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
                      HashtageWidget(text: tweet.text),
                      if (tweet.tweetType == TweetType.image)
                        CrousalImage(imageLinks: tweet.imageList),
                      if (tweet.link.isNotEmpty) ...[
                        const SizedBox(),
                        AnyLinkPreview(
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            link: 'http://${tweet.link}'),
                      ],
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        margin: const EdgeInsets.only(top: 10, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TweetIconButton(
                                pathName: AssetsConstants.viewsIcon,
                                text: (tweet.likes.length +
                                        tweet.commentIds.length)
                                    .toString(),
                                onTap: () {}),
                            TweetIconButton(
                                pathName: AssetsConstants.commentIcon,
                                text: (tweet.commentIds.length).toString(),
                                onTap: () {}),
                            TweetIconButton(
                                pathName: AssetsConstants.retweetIcon,
                                text: (tweet.reshareCount).toString(),
                                onTap: () async {
                                  context.read<HomeBloc>().add(ReshareTweet(
                                      tweet: tweet,
                                      currentUserId: currentUserId));
                                }),
                            LikeButton(
                              isLiked: tweet.likes.contains(currentUserId),
                              onTap: (isLiked) async {
                                context.read<HomeBloc>().add(LikeTweet(
                                    tweet: tweet,
                                    currentUserId: currentUserId));
                                return !isLiked;
                              },
                              likeBuilder: (isLiked) {
                                return SvgPicture.asset(
                                  isLiked
                                      ? AssetsConstants.likeFilledIcon
                                      : AssetsConstants.likeOutlinedIcon,
                                  color: isLiked
                                      ? Pallete.redColor
                                      : Pallete.greyColor,
                                );
                              },
                              likeCount: tweet.likes.length,
                              countBuilder: (likeCount, isLiked, text) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        color: isLiked
                                            ? Pallete.redColor
                                            : Pallete.whiteColor),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.share_outlined))
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              color: Pallete.greyColor,
              thickness: 0.5,
            ),
          ],
        );
      },
    );
  }
}
