part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeCurrentUserDataFetching extends HomeState {}

final class HomeCurrentUserDataFetchingFailed extends HomeState {
  final String message;
  HomeCurrentUserDataFetchingFailed({required this.message});
}

final class HomeCurrentUserDataFetched extends HomeState {
  final Map<String, dynamic> userData;
  HomeCurrentUserDataFetched({
    required this.userData,
  });
}
