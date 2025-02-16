import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/usecases/create_tweet_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_all_tweets_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/get_user_data_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/like_tweet_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/reshare_tweet_usecase.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchAllTweetsUsecase _fetchAllTweetsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final CreateTweetUsecase _createTweetUsecase;
  final LikeTweetUsecase _likeTweetUsecase;
  final ReshareTweetUsecase _reshareTweetUsecase;

  HomeBloc({
    required FetchAllTweetsUsecase fetchAllTweetsUsecase,
    required GetUserDataUsecase getUserDataUsecase,
    required CreateTweetUsecase createTweetUsecase,
    required LikeTweetUsecase likeTweetUsecase,
    required ReshareTweetUsecase reshareTweetUsecase,
  })  : _fetchAllTweetsUsecase = fetchAllTweetsUsecase,
        _getUserDataUsecase = getUserDataUsecase,
        _createTweetUsecase = createTweetUsecase,
        _likeTweetUsecase = likeTweetUsecase,
        _reshareTweetUsecase = reshareTweetUsecase,
        super(const HomeInitial()) {
    on<FetchAllTweets>(_onFetchAllTweets);
    on<GetUser>(_onGetUser);
    on<ShareTweet>(_onShareTweet);
    on<LikeTweet>(_likeTweet);
    on<ReshareTweet>(_reshareTweet);
  }
  // resharing the tweet
  Future<void> _reshareTweet(
      ReshareTweet event, Emitter<HomeState> emit) async {
    try {
      final response = await _reshareTweetUsecase.call(ReshareTweetParams(
          tweet: event.tweet, currentUserId: event.currentUserId));
      response.fold((failure) {
        emit(state.copyWith(errorMessage: "could'nt shared the tweet"));
      }, (success) {
        final updatedTweets = List<Tweet>.from(state.tweets)
          ..insert(0, success);

        emit(state.copyWith(tweets: updatedTweets));
      });
    } catch (e) {
      log('catch bloc ${e.toString()}');
      emit(state.copyWith(errorMessage: null));
    }
  }

// Liking the tweet
  Future<void> _likeTweet(LikeTweet event, Emitter<HomeState> emit) async {
    try {
      final result = await _likeTweetUsecase.call(LikeTweetParams(
          tweet: event.tweet, currentUserId: event.currentUserId));
      result.fold((failure) {
        state.copyWith(errorMessage: null);
      }, (success) {
        log('this is success state');
        state.copyWith(errorMessage: null);
      });
    } catch (e) {
      log('catch bloc ${e.toString()}');
      emit(state.copyWith(errorMessage: null));
    }
  }

  // Fetch all tweets
  Future<void> _onFetchAllTweets(
      FetchAllTweets event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await _fetchAllTweetsUsecase.call(NoParams());
      result.fold(
        (failure) => emit(
            state.copyWith(isLoading: false, errorMessage: failure.toString())),
        (tweets) => emit(state.copyWith(tweets: tweets, isLoading: false)),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // Fetch user data
  Future<void> _onGetUser(GetUser event, Emitter<HomeState> emit) async {
    if (state.users.containsKey(event.userId)) return;

    try {
      final result =
          await _getUserDataUsecase.call(UserParams(userId: event.userId));
      result.fold(
        (failure) {
          emit(state.copyWith(
              errorMessage: 'Failed to fetch user: ${failure.message}'));
        },
        (user) {
          final updatedUsers = {
            ...state.users,
            event.userId: user
          }; // More efficient way
          emit(state.copyWith(users: updatedUsers));
        },
      );
    } catch (e, stackTrace) {
      log("Error fetching user: $e\n$stackTrace"); // Improved debugging
      emit(state.copyWith(errorMessage: 'Failed to fetch user'));
    }
  }

  // Share a new tweet
  Future<void> _onShareTweet(ShareTweet event, Emitter<HomeState> emit) async {
    try {
      final result = await _createTweetUsecase.call(CreateTweetParams(
          userId: event.userId,
          tweetText: event.tweetText,
          tweetImages: event.imagesList));
      result.fold(
        (failure) =>
            emit(state.copyWith(errorMessage: 'Failed to share tweet')),
        (newTweet) {
          add(FetchAllTweets());
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to share tweet'));
    }
  }
}
