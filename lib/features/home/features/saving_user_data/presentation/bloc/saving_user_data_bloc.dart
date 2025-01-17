import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/home/features/saving_user_data/domain/usecase/saving_user_data_usecase.dart';

part 'saving_user_data_event.dart';
part 'saving_user_data_state.dart';

class SavingUserDataBloc
    extends Bloc<SavingUserDataEvent, SavingUserDataState> {
  final SaveUserDataUseCase _saveUserDataUseCase;
  SavingUserDataBloc({
    required SaveUserDataUseCase saveUserDataUseCase,
  })  : _saveUserDataUseCase = saveUserDataUseCase,
        super(SavingUserDataInitial()) {
    on<SavingUserDataEvent>((event, emit) {});
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
        emit(SavingUserDataFailure(message: failure.message));
      }, (success) {
        log('success state');
        emit(SavingUserDataSuccess());
      });
    });
  }
}
