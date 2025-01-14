import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/usecases/usecase.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/get_current_user.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_in_usecase.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final AppUserCubit _appUserCubit;
  final GetCurrentUser _getCurrentUser;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required GetCurrentUser getCurrentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _getCurrentUser = getCurrentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      if (event is SignUpEvent) {
        emit(AuthLoading());
      }
    });
    on<SignUpEvent>((event, emit) async {
      final response = await _userSignUp
          .call(UserSignUpParams(email: event.email, password: event.password));
      response.fold((failure) {
        log(failure.message);
        emit(AuthFailure(message: failure.message));
      }, (user) {
        log(user.toString());
        _emitAuthSuccess(user, emit);
      });
    });
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await _userSignIn
          .call(UserSignInParams(email: event.email, password: event.password));
      response.fold((failure) {
        emit(AuthFailure(message: failure.message));
      }, (response) {
        _emitAuthSuccess(response, emit);
      });
    });
    on<AuthIsUserLoggedIn>((event, emit) async {
      final response = await _getCurrentUser.call(NoParams());
      response.fold((failure) {
        emit(AuthFailure(message: failure.message));
        print(failure.message);
      }, (user) {
        _emitAuthSuccess(user, emit);
        print(user.email);
      });
    });
  }
  void _emitAuthSuccess(
    UserEntity user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
