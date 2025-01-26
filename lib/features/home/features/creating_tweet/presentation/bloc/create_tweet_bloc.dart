import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/home/features/creating_tweet/domain/usecases/create_tweet_usecase.dart';

part 'create_tweet_event.dart';
part 'create_tweet_state.dart';

class CreateTweetBloc extends Bloc<CreateTweetEvent, CreateTweetState> {
  final CreateTweetUsecase _createTweetUsecase;
  CreateTweetBloc({
    required CreateTweetUsecase createTweetUsecase,
  })  : _createTweetUsecase = createTweetUsecase,
        super(CreateTweetInitial()) {
    on<CreateTweetEvent>((event, emit) {});
    on<CreateUserTweetEvent>((event, emit) async {
      log('i am in Bloc');
      final response = await _createTweetUsecase.call(CreateTweetParams(
          userId: event.userId,
          tweetText: event.tweetText,
          tweetImages: event.tweetImages));
      response.fold((failure) {
        emit(CreateTweetFailure(message: failure.message));
      }, (success) {
        emit(CreateTweetSuccess());
      });
    });
  }
}
