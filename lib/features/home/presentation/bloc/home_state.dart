part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class UserDataLoading extends HomeState {}

final class UserDataSavingFailed extends HomeState {
  final String message;
  UserDataSavingFailed({required this.message});
}

final class UserDataSavingSucceed extends HomeState {}
