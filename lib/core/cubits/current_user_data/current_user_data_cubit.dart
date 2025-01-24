import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/entities/user_presentation_model.dart';

part 'current_user_data_state.dart';

class CurrentUserDataCubit extends Cubit<CurrentUserDataState> {
  CurrentUserDataCubit() : super(CurrentUserDataInitial());
  void updateUser(UserPresentationModel userData) {
    if (userData.isEmpty()) {
      emit(CurrentUserDataInitial());
    } else {
      emit(CurrentUserDataLoaded(userData: userData));
    }
  }
}
