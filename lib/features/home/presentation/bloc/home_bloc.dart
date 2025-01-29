import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/usecases/create_tweet_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_all_tweets_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchAllTweetsUsecase _fetchAllTweetsUsecase;
  final CreateTweetUsecase _createTweetUsecase;

  HomeBloc({
    required CreateTweetUsecase createTweetUseCase,
    required FetchAllTweetsUsecase fetchAllTweetsUseCase,
  })  : _fetchAllTweetsUsecase = fetchAllTweetsUseCase,
        _createTweetUsecase = createTweetUseCase,
        super(HomeInitial()) {
    // GETTING ALL TWEETS;
    on<FetchAllTweets>((event, emit) async {
      final response = await _fetchAllTweetsUsecase.call(NoParams());
      response.fold((failure) {
        log(failure.message);
        emit(HomeFailure(message: failure.message));
      }, (success) {
        log(success.toString());
        emit(FetchingTweetsSuccess(tweets: success));
      });
    });
    // sharing tweet;
    on<ShareTweet>((event, emit) async {
      final response = await _createTweetUsecase.call(CreateTweetParams(
          userId: event.userId,
          tweetText: event.tweetText,
          tweetImages: event.tweetImages));
      response.fold((failure) {
        log(failure.message);
        emit(HomeFailure(message: failure.message));
      }, (success) {
        emit(ShareTweetSucceed());
      });
    });
  }
}
