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
  final UserPresentationModel userData;
  HomeCurrentUserDataFetched({
    required this.userData,
  });
}

final class HomeFetchAllTweetsSuccess extends HomeState {
  final List<Tweet> tweets;
  HomeFetchAllTweetsSuccess({
    required this.tweets,
  });
}

final class HomeFetchAllTweetsFailure extends HomeState {
  final String message;
  HomeFetchAllTweetsFailure({required this.message});
}
