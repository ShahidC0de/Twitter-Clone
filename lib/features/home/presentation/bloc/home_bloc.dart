import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/cubits/current_user_data/current_user_data_cubit.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_all_tweets_usecase.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_current_user_data_usecase.dart';
import 'package:twitter_clone/core/entities/user_presentation_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCurrentUserDataUsecase _fetchCurrentUserDataUsecase;
  final CurrentUserDataCubit _currentUserDataCubit;
  final FetchAllTweetsUsecase _fetchAllTweetsUsecase;

  HomeBloc({
    required FetchCurrentUserDataUsecase fetchCurrentUserDataUsecase,
    required FetchAllTweetsUsecase fetchAllTweetsUseCase,
    required CurrentUserDataCubit currentuserDataCubit,
  })  : _fetchCurrentUserDataUsecase = fetchCurrentUserDataUsecase,
        _currentUserDataCubit = currentuserDataCubit,
        _fetchAllTweetsUsecase = fetchAllTweetsUseCase,
        super(HomeInitial()) {
    // GETTING CURRENT USER'S DATA;
    on<HomeFetchCurrentUserDataEvent>((event, emit) async {
      emit(HomeCurrentUserDataFetching());
      final response = await _fetchCurrentUserDataUsecase
          .call(UserIdParams(userId: event.userId));
      response.fold((failure) {
        emit(HomeFetchAllTweetsFailure(message: failure.message));
      }, (success) {
        _emitSuccessState(success.toPresentationModel(), emit);
      });
    });
    // GETTING ALL TWEETS;
    on<HomeFetchAllTweetsEvent>((event, emit) async {
      final response = await _fetchAllTweetsUsecase.call(NoParams());
      response.fold((failure) {
        log(failure.message);
        emit(HomeFetchAllTweetsFailure(message: failure.message));
      }, (success) {
        log(success.toString());
        emit(HomeFetchAllTweetsSuccess(tweets: success));
      });
    });
  }
  void _emitSuccessState(
      UserPresentationModel userPresentationModel, Emitter<HomeState> emit) {
    _currentUserDataCubit.updateUser(userPresentationModel);

    emit(HomeCurrentUserDataFetched(userData: userPresentationModel));
  }
}
