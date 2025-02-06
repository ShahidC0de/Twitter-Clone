import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/constants/assets_constants.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                onTap: () {}),
                            LikeButton(
                              // ignore: body_might_complete_normally_nullable
                              likeBuilder: (isLiked) {
                                isLiked
                                    ? SvgPicture.asset(
                                        AssetsConstants.likeFilledIcon,
                                        color: Pallete.redColor,
                                      )
                                    : SvgPicture.asset(
                                        AssetsConstants.likeOutlinedIcon,
                                        color: Pallete.greyColor,
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
                      const SizedBox(
                        height: 1,
                      )
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
