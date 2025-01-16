import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/home/domain/usecases/save_user_data.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SaveUserDataUseCase _saveUserDataUseCase;
  HomeBloc({
    required SaveUserDataUseCase saveUserDataUseCase,
  })  : _saveUserDataUseCase = saveUserDataUseCase,
        super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<SaveUserDataEvent>((event, emit) async {
      final response = await _saveUserDataUseCase.call(UserDataParams(
        uid: event.uid,
        name: event.name,
        email: event.email,
        followers: event.followers,
        following: event.following,
        profilePic: event.profilePic,
        bannerPic: event.bannerPic,
        bio: event.bio,
        isTwitterBlue: event.isTwitterBlue,
      ));
      response.fold((failure) {
        log(failure.message);
        emit(UserDataSavingFailed(message: failure.message));
      }, (success) {
        log('success state');
        emit(UserDataSavingSucceed());
      });
    });
  }
}
