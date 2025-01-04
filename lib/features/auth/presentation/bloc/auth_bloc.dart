import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  AuthBloc({
    required UserSignUp userSignUp,
  })  : _userSignUp = userSignUp,
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
        emit(AuthSuccess(user: user));
      });
    });
  }
}
