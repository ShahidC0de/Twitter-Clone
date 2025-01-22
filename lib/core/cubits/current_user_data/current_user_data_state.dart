part of 'current_user_data_cubit.dart';

@immutable
sealed class CurrentUserDataState {}

final class CurrentUserDataInitial extends CurrentUserDataState {}

final class CurrentUserDataLoaded extends CurrentUserDataState {
  final UserPresentationModel userData;
  CurrentUserDataLoaded({
    required this.userData,
  });
}
