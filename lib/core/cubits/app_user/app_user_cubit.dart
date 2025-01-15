import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/entities/auth_user_entity.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());
  void updateUser(AuthUserEntity? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      AppUserLoggedIn(user: user);
    }
  }
}
