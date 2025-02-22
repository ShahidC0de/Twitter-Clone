import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/home/presentation/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:twitter_clone/features/user_profile/presentation/widgets/follow_count.dart';

class UserProfileItem extends StatefulWidget {
  final UserEntity user;
  const UserProfileItem({super.key, required this.user});

  @override
  State<UserProfileItem> createState() => _UserProfileItemState();
}

class _UserProfileItemState extends State<UserProfileItem> {
  @override
  void initState() {
    context
        .read<UserProfileBloc>()
        .add(GetUserTweetsEvent(userId: widget.user.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    bool _checkTheUser(String currentUser) {
      final blocProvider = BlocProvider.of<AppUserCubit>(context);
      final state = blocProvider.state;
      if (state is AppUserLoggedIn) {
        if (state.user.uid == currentUser) {
          return true;
        }
        return false;
      }
      return false;
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
              expandedHeight: 150,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                      child: widget.user.bannerPic.isEmpty
                          ? Container(
                              color: Pallete.blueColor,
                            )
                          : Image.network(widget.user.bannerPic)),
                  Positioned(
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.user.profilePic,
                      ),
                      radius: 45,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.all(20),
                    child: OutlinedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Pallete.whiteColor,
                                  width: 1.5,
                                )),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25)),
                        child: Text(
                          _checkTheUser(widget.user.uid)
                              ? 'Edit Profile'
                              : 'Follow',
                          style: const TextStyle(
                            color: Pallete.whiteColor,
                          ),
                        )),
                  )
                ],
              )),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverList(
                delegate: SliverChildListDelegate(
              [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${widget.user.name}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Pallete.greyColor,
                  ),
                ),
                Text(
                  widget.user.bio,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    FollowCount(
                        count: widget.user.followers.length, text: 'Followers'),
                    const SizedBox(
                      width: 15,
                    ),
                    FollowCount(
                        count: widget.user.following.length, text: 'Following')
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                const Divider(
                  color: Pallete.whiteColor,
                ),
              ],
            )),
          )
        ];
      },
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Loader(),
            );
          } else if (state.errorMessage != null) {
            return Center(
              child: Text(state.errorMessage.toString()),
            );
          }
          return Expanded(
            child: ListView.builder(
                itemCount: state.userTweets.length,
                itemBuilder: (context, index) {
                  final singleTweet = state.userTweets[index];
                  return TweetCard(tweet: singleTweet);
                }),
          );
        },
      ),
    );
  }
}
