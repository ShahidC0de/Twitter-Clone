part of 'saving_user_data_bloc.dart';

@immutable
sealed class SavingUserDataState {}

final class SavingUserDataInitial extends SavingUserDataState {}

final class SavingUserDataLoading extends SavingUserDataState {}

final class SavingUserDataFailure extends SavingUserDataState {
  final String message;
  SavingUserDataFailure({required this.message});
}

final class SavingUserDataSuccess extends SavingUserDataState {}
