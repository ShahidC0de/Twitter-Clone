import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/create_tweet_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_all_tweets_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/get_user_data_usecase.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchAllTweetsUsecase _fetchAllTweetsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final CreateTweetUsecase _createTweetUsecase;

  HomeBloc({
    required FetchAllTweetsUsecase fetchAllTweetsUsecase,
    required GetUserDataUsecase getUserDataUsecase,
    required CreateTweetUsecase createTweetUsecase,
  })  : _fetchAllTweetsUsecase = fetchAllTweetsUsecase,
        _getUserDataUsecase = getUserDataUsecase,
        _createTweetUsecase = createTweetUsecase,
        super(const HomeInitial()) {
    on<FetchAllTweets>(_onFetchAllTweets);
    on<GetUser>(_onGetUser);
    on<ShareTweet>(_onShareTweet);
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
        (failure) => emit(state.copyWith(errorMessage: 'Failed to fetch user')),
        (user) {
          final updatedUsers = Map<String, UserEntity>.from(state.users)
            ..[event.userId] = user;
          emit(state.copyWith(users: updatedUsers));
        },
      );
    } catch (e) {
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
