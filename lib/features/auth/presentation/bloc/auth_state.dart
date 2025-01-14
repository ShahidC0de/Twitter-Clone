part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

final class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess({required this.user});
}

final class CurrentUserExist extends AuthState {
  final UserEntity user;
  CurrentUserExist({required this.user});
}
