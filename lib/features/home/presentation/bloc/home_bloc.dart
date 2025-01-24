import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/cubits/current_user_data/current_user_data_cubit.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_current_user_data_usecase.dart';
import 'package:twitter_clone/core/entities/user_presentation_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCurrentUserDataUsecase _fetchCurrentUserDataUsecase;
  final CurrentUserDataCubit _currentUserDataCubit;

  HomeBloc({
    required FetchCurrentUserDataUsecase fetchCurrentUserDataUsecase,
    required CurrentUserDataCubit currentuserDataCubit,
  })  : _fetchCurrentUserDataUsecase = fetchCurrentUserDataUsecase,
        _currentUserDataCubit = currentuserDataCubit,
        super(HomeInitial()) {
    on<HomeFetchCurrentUserDataEvent>((event, emit) async {
      emit(HomeCurrentUserDataFetching());
      final response = await _fetchCurrentUserDataUsecase
          .call(UserIdParams(userId: event.userId));
      response.fold((failure) {
        emit(HomeCurrentUserDataFetchingFailed(message: failure.message));
        log(failure.message);
      }, (success) {
        log(success.profilePic);
        _emitSuccessState(success.toPresentationModel(), emit);
        log(success.name);
      });
    });
  }
  void _emitSuccessState(
      UserPresentationModel userPresentationModel, Emitter<HomeState> emit) {
    log('emitting success and updating the user in currentusercubit');
    log(userPresentationModel.uid);

    _currentUserDataCubit.updateUser(userPresentationModel);
    log('updated the user in currentusercubit');

    emit(HomeCurrentUserDataFetched(userData: userPresentationModel));
  }
}
