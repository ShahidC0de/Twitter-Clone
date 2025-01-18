part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeFetchCurrentUserDataEvent extends HomeEvent {
  final String userId;
  HomeFetchCurrentUserDataEvent({
    required this.userId,
  });
}
