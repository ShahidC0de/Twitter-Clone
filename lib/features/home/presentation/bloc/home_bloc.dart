import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_current_user_data_usecase.dart';
import 'package:twitter_clone/features/home/presentation/presentation_models/user_presentation_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCurrentUserDataUsecase _fetchCurrentUserDataUsecase;

  HomeBloc({
    required FetchCurrentUserDataUsecase fetchCurrentUserDataUsecase,
  })  : _fetchCurrentUserDataUsecase = fetchCurrentUserDataUsecase,
        super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<HomeFetchCurrentUserDataEvent>((event, emit) async {
      final response = await _fetchCurrentUserDataUsecase
          .call(UserIdParams(userId: event.userId));
      response.fold((failure) {
        emit(HomeCurrentUserDataFetchingFailed(message: failure.message));
        log(failure.message);
      }, (success) {
        emit(HomeCurrentUserDataFetched(
          userData: success.toPresentationModel(),
          //     userData: UserPresentationModel(
          //   uid: success.uid,
          //   name: success.name,
          //   email: success.email,
          //   followers: success.followers,
          //   following: success.following,
          //   profilePic: success.profilePic,
          //   bannerPic: success.bannerPic,
          //   bio: success.bio,
          //   isTwitterBlue: success.isTwitterBlue,
          // )
        ));
        log(success.name);
      });
    });
  }
}
